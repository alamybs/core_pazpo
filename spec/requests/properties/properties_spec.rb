require 'rails_helper'

RSpec.describe "Api::V1::Properties", type: :request do
  describe "[POST] Endpoint /properties" do
    before :each do
      @user = FactoryGirl.create(:user)
    end
    it "should returns 200 with valid params when succes creat property" do
      params = {
        description:          "Jual rumah teletubis.",
        price:                "2.000.000.000",
        property_type:        1,
        property_category_id: 1
      }
      post "/properties",
           params:  params,
           headers: {'Authorization'  => @user.authentication_token,
                     'Accept-Version' => 'v1'}

      expect(response.status).to eq(201)
      expect(JSON.parse(response.body)['data']['property']['property_category']).to eq({"title" => "Rumah"})
      expect(JSON.parse(response.body)['data']['property']['description']).to eq("Jual rumah teletubis.")
      expect(JSON.parse(response.body)['data']['property']['price']).to eq("2000000000.0")
      expect(JSON.parse(response.body)['data']['property']['property_type']).to eq("WTB")
    end
  end
  describe "[GET] Endpoint /properties/current" do
    before :each do
      @user       = FactoryGirl.create(:user)
      @property   = FactoryGirl.create(:property, user_id: @user.id)
      @property_2 = FactoryGirl.create(:property, user_id: @user.id)
    end
    it "should returns 200 with valid params when succes get current property" do
      get "/properties/current",
          headers: {'Authorization'  => @user.authentication_token,
                    'Accept-Version' => 'v1'}

      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)['data']['properties'].size).to eq(2)
    end
  end
  describe "[GET] Endpoint /properties" do
    before :each do
      @user       = FactoryGirl.create(:user)
      @user_2     = FactoryGirl.create(:user_2)
      @property   = FactoryGirl.create(:property, user_id: @user.id)
      @property_2 = FactoryGirl.create(:property, user_id: @user_2.id, description: "Dicari Rumah mahal.", property_type: 2)
    end
    it "should returns 200 with valid params when succes get current property" do
      get "/properties",
          params:  {id: @property_2.id},
          headers: {'Authorization'  => @user.authentication_token,
                    'Accept-Version' => 'v1'}

      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)['data']['property']['description']).to eq('Dicari Rumah mahal.')
    end
  end
end

