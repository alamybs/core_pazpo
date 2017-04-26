require 'rails_helper'

RSpec.describe "Api::V1::Users", type: :request do
  describe "[GET] Endpoint /users/current" do
    before :each do
      @user = FactoryGirl.create(:user)
    end
    it "should returns 200 with valid params" do
      get "/users/current",
          headers: {'Authorization'  => @user.authentication_token,
                    'Accept-Version' => 'v1'}

      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)['data']['user']['name']).to eq(@user.name)
      expect(JSON.parse(response.body)['data']['user']['email']).to eq(@user.email)
      expect(JSON.parse(response.body)['data']['user']['role']).to eq(@user.role)
      expect(JSON.parse(response.body)['data']['user']['account_kit_id']).to eq(@user.account_kit_id)
      expect(JSON.parse(response.body)['data']['user']['authentication_token']).to eq(@user.authentication_token)
    end
  end
  describe "[GET] Endpoint /users" do
    before :each do
      @user = FactoryGirl.create(:user)
    end
    it "should returns 200 with valid params" do
      get "/users/show",
          params:  {id: @user.id},
          headers: {'Authorization'  => @user.authentication_token,
                    'Accept-Version' => 'v1'}

      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)['data']['user']['name']).to eq(@user.name)
      expect(JSON.parse(response.body)['data']['user']['email']).to eq(@user.email)
      expect(JSON.parse(response.body)['data']['user']['role']).to eq(@user.role)
      expect(JSON.parse(response.body)['data']['user']['account_kit_id']).to eq(nil)
      expect(JSON.parse(response.body)['data']['user']['authentication_token']).to eq(nil)
    end
  end
end

