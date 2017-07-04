require 'rails_helper'

RSpec.describe "Api::V1::Hastags", type: :request do
  describe "[GET] Endpoint /hastags" do
    before :each do
      @user       = FactoryGirl.create(:user)
      @property   = FactoryGirl.create(:property, user_id: @user.id, tag_list: "satu, dua, tiga")
      @property_2 = FactoryGirl.create(:property, user_id: @user.id, tag_list: "satu")
      @property_3 = FactoryGirl.create(:property, user_id: @user.id, tag_list: "saturus")
    end
    it "should returns 200 with valid params when success search hastags" do
      params = {
        title: "satu",
      }
      get "/hastags",
           params:  params,
           headers: {'Authorization'  => @user.authentication_token,
                     'Accept-Version' => 'v1'}

      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)['data']['hastags'].first).to eq({"title"=>"satu", "count"=>2})
      expect(JSON.parse(response.body)['data']['hastags'].last).to eq({"title"=>"saturus", "count"=>1})
    end
  end
end

