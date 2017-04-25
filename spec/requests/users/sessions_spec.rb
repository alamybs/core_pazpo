require 'rails_helper'

RSpec.describe "Api::V1::Users", type: :request do
  before(:each) do
    @get_accesstoken = stub_request(:get, "https://graph.accountkit.com/v1.2/access_token?grant_type=authorization_code&code=authorizationcode&access_token=AA|facebookappid|facebookappsecret").to_return(
      status: 200,
      body:   {
                id:                         "123141241241",
                access_token:               "accesstoken",
                token_refresh_interval_sec: 232342342
              }.to_json
    )
    @get_user        = stub_request(:get, "https://graph.accountkit.com/v1.2/me/?access_token=accesstoken").to_return(
      status: 200,
      body:   {
                id:    "12345",
                phone: {
                  number:          "+6285345678998",
                  country_prefix:  "1",
                  national_number: "5551234567"
                }
              }.to_json
    )
  end
  describe "[POST] Endpoint /sessions/sign_up" do
    it "should returns 200 with valid params" do
      params = {
        name:               "Alam",
        email:              "alam@pazpo.id",
        role:               1,
        authorization_code: "authorizationcode",
        picture:            Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, '/spec/fixtures/avatar.jpg'))),
      }
      post "/sessions/sign_up",
           params:  params,
           headers: {'Accept-Version' => 'v1'}

      expect(response.status).to eq(201)
      expect(JSON.parse(response.body)['data']['user']['phone_number']).to eq('+6285345678998')
      expect(JSON.parse(response.body)['data']['user']['name']).to eq('Alam')
      expect(JSON.parse(response.body)['data']['user']['email']).to eq('alam@pazpo.id')
      expect(JSON.parse(response.body)['data']['user']['role']).to eq('Property Agen')
      expect(JSON.parse(response.body)['data']['user']['account_kit_id']).to eq('12345')
    end
  end
  describe "[POST] Endpoint /sessions/sign_in" do
    before :each do
      @user = FactoryGirl.create(:user)
    end
    it "should returns 200 with valid params" do
      post "/sessions/sign_in",
           params:  {authorization_code: "authorizationcode"},
           headers: {'Accept-Version' => 'v1'}

      expect(response.status).to eq(201)
      expect(JSON.parse(response.body)['data']['user']['name']).to eq(@user.name)
      expect(JSON.parse(response.body)['data']['user']['email']).to eq(@user.email)
      expect(JSON.parse(response.body)['data']['user']['role']).to eq(@user.role)
      expect(JSON.parse(response.body)['data']['user']['account_kit_id']).to eq(@user.account_kit_id)
      expect(JSON.parse(response.body)['data']['user']['authentication_token']).to eq(@user.authentication_token)
    end
  end
end

