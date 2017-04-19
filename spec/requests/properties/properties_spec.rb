require 'rails_helper'

RSpec.describe "Api::V1::Properties", type: :request do
  describe "[POST] Endpoint /properties" do
    before :each do
      @user = FactoryGirl.create(:user)
    end
    it "should returns 200 with valid params when succes creat property" do
      params = {
        description: "Jual rumah teletubis.",
        price:       "2.000.000.000",
        property_category_id: 1
      }
      post "/properties",
          params:  params,
          headers: {'Authorization'  => @user.authentication_token,
                    'Accept-Version' => 'v1'}

      expect(response.status).to eq(201)
      expect(JSON.parse(response.body)['data']['property']['property_category']).to eq({"title"=>"Rumah"})
      expect(JSON.parse(response.body)['data']['property']['description']).to eq("Jual rumah teletubis.")
      expect(JSON.parse(response.body)['data']['property']['price']).to eq("2000000000.0")
    end
  end
end

