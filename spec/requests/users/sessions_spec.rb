require 'rails_helper'

RSpec.describe "Api::V1::Users", type: :request do
  before(:each) do
  end
  describe "[POST] Endpoint /sessions/sign_up" do
    it "should returns 200 with valid params" do
      params = {
        name:           "Alam",
        email:          "alam@pazpo.id",
        phone_number:   "0851234567890",
        role:           1,
        account_kit_id: "thisisaccountkitid",
      }
      post "/sessions/sign_up",
           params:  params,
           headers: {'Accept-Version' => 'v1'}

      expect(response.status).to eq(201)
      expect(JSON.parse(response.body)['data']['name']).to eq('Alam')
      expect(JSON.parse(response.body)['data']['email']).to eq('alam@pazpo.id')
      expect(JSON.parse(response.body)['data']['role']).to eq('Property Agen')
      expect(JSON.parse(response.body)['data']['account_kit_id']).to eq('thisisaccountkitid')
    end
  end
  describe "[POST] Endpoint /sessions/sign_in" do
    before :each do
      @user = FactoryGirl.create(:user)
    end
    it "should returns 200 with valid params" do
      post "/sessions/sign_in",
           params:  {account_kit_id: @user.account_kit_id},
           headers: {'Accept-Version' => 'v1'}

      expect(response.status).to eq(201)
      expect(JSON.parse(response.body)['data']['name']).to eq(@user.name)
      expect(JSON.parse(response.body)['data']['email']).to eq(@user.email)
      expect(JSON.parse(response.body)['data']['role']).to eq(@user.role)
      expect(JSON.parse(response.body)['data']['account_kit_id']).to eq(@user.account_kit_id)
      expect(JSON.parse(response.body)['data']['authentication_token']).to eq(@user.authentication_token)
    end
  end
end

