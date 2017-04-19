require 'rails_helper'

RSpec.describe "Api::V1::PropertyCategories", type: :request do
  describe "[GET] Endpoint /property_categories" do
    before :each do
      @user = FactoryGirl.create(:user)
    end
    it "should returns 200 with valid params when succes get property_categories" do
      get "/property_categories",
          headers: {'Authorization'  => @user.authentication_token,
                    'Accept-Version' => 'v1'}

      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)["data"]).to eq([{"id"=>1, "title"=>"Rumah"}, {"id"=>2, "title"=>"Ruko"}, {"id"=>3, "title"=>"Apartemen"}, {"id"=>4, "title"=>"Gudang"}, {"id"=>5, "title"=>"Kantor"}, {"id"=>6, "title"=>"Tanah"}])
    end
  end
end

