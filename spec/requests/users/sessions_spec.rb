require 'rails_helper'

RSpec.describe "Api::V1::Users", type: :request do
  before(:each) do
  end
  describe "[POST] Endpoint /sessions/" do
    it "should returns 200 with valid params" do
      params = {
        name:                 "Alam",
        email:                "alam@pazpo.id",
        phone_number:         "0851234567890",
        role:                 1,
        authentication_token: "thisisatokens",
      }
      post "/sessions/sign_up",
           params:  params,
           headers: {'Accept-Version' => 'v1'}

      expect(response.status).to eq(201)
      expect(JSON.parse(response.body)['data']['name']).to eq('Alam')
      expect(JSON.parse(response.body)['data']['email']).to eq('alam@pazpo.id')
      expect(JSON.parse(response.body)['data']['role']).to eq('Property Agen')
      expect(JSON.parse(response.body)['data']['authentication_token']).to eq('thisisatokens')
    end
  end
end

