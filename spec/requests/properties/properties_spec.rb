require 'rails_helper'

RSpec.describe "Api::V1::Properties", type: :request do
  describe "[POST] Endpoint /properties" do
    before :each do
      @user = FactoryGirl.create(:user)
    end
    it "should returns 200 with valid params when succes creat property" do
      params = {
        description:   "Jual rumah teletubis.",
        price:         "2.000.000.000",
        property_type: 2,
        hastags:       ["satu", "dua"]
      }
      post "/properties",
           params:  params,
           headers: {'Authorization'  => @user.authentication_token,
                     'Accept-Version' => 'v1'}

      expect(response.status).to eq(201)
      expect(JSON.parse(response.body)['data']['property']['description']).to eq("Jual rumah teletubis.")
      expect(JSON.parse(response.body)['data']['property']['price']).to eq("2000000000.0")
      expect(JSON.parse(response.body)['data']['property']['hastags']).to eq(["satu", "dua"])
    end
  end
  describe "[PUT] Endpoint /properties" do
    before :each do
      @user     = FactoryGirl.create(:user)
      @property = FactoryGirl.create(:property, user_id: @user.id)
    end
    it "should returns 200 with valid params when succes update property" do
      params = {
        id:            @property.id,
        description:   "Jual rumah Dora.",
        price:         "1.000.000.000",
        property_type: 1,
        hastags:       ["satu", "tiga"]
      }
      put "/properties",
          params:  params,
          headers: {'Authorization'  => @user.authentication_token,
                    'Accept-Version' => 'v1'}

      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)['data']['property']['description']).to eq("Jual rumah Dora.")
      expect(JSON.parse(response.body)['data']['property']['price']).to eq("1000000000.0")
      expect(JSON.parse(response.body)['data']['property']['hastags']).to eq(["satu", "tiga"])
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
  describe "[GET] Endpoint /properties/show" do
    before :each do
      @user       = FactoryGirl.create(:user)
      @user_2     = FactoryGirl.create(:user_2)
      @property   = FactoryGirl.create(:property, user_id: @user.id)
      @property_2 = FactoryGirl.create(:property, user_id: @user_2.id, description: "Dicari Rumah mahal.", tag_list: "satu,dua,tiga")
    end
    it "should returns 200 with valid params when succes get property by id" do
      get "/properties/show",
          params:  {id: @property_2.id},
          headers: {'Authorization'  => @user.authentication_token,
                    'Accept-Version' => 'v1'}

      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)['data']['property']['description']).to eq('Dicari Rumah mahal.')
    end
  end
  describe "[DELETE] Endpoint /properties" do
    before :each do
      @user       = FactoryGirl.create(:user)
      @property   = FactoryGirl.create(:property, user_id: @user.id)
      @property_2 = FactoryGirl.create(:property, user_id: @user.id, description: "Dicari Rumah mahal.")
    end
    it "should returns 200 with valid params when succes destroy current property" do
      delete "/properties",
             params:  {id: @property_2.id},
             headers: {'Authorization'  => @user.authentication_token,
                       'Accept-Version' => 'v1'}

      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)['data']).to eq({"messages" => "Success destroy property with id : #{@property_2.id}."})
    end
  end
  describe "[GET] Endpoint /properties" do
    before :each do
      @user   = FactoryGirl.create(:user)
      @user_2 = FactoryGirl.create(:user_2)
      @user_3 = FactoryGirl.create(:user_3)

      FactoryGirl.create(:follow, user_id: @user.id, follow_id: @user_2.id)

      @property   = FactoryGirl.create(:property, user_id: @user.id, description: 'Description 2', created_at: Time.now - 5.minutes, tag_list: "satu,dua,tiga,lima")
      @property_2 = FactoryGirl.create(:property, user_id: @user.id, description: 'Description 2', created_at: Time.now - 4.minutes, tag_list: "satu,dua,tiga")
      @property_3 = FactoryGirl.create(:property, user_id: @user_2.id, description: 'Description 3', created_at: Time.now - 3.minutes, tag_list: "satu,dua,tiga,lima")
      @property_4 = FactoryGirl.create(:property, user_id: @user_2.id, description: 'Description 4', created_at: Time.now - 2.minutes, tag_list: "satu,dua,tiga")
      @property_5 = FactoryGirl.create(:property, user_id: @user_2.id, description: 'Description 5', created_at: Time.now - 1.minutes, tag_list: "satu,dua,tiga,lima")
    end
    it "should returns 200 with valid params when succes get all property (5)" do
      get "/properties",
          headers: {'Authorization'  => @user.authentication_token,
                    'Accept-Version' => 'v1'}

      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)['data']['properties'].size).to eq(5)
    end

    it "should returns 200 with valid params when succes get filter user name (3)" do
      get "/properties",
          params:  {q: "Bima"},
          headers: {'Authorization'  => @user.authentication_token,
                    'Accept-Version' => 'v1'}

      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)['data']['properties'].size).to eq(3)
    end

    it "should returns 200 with valid params when succes get filter description (5)" do
      get "/properties",
          params:  {q: "Description"},
          headers: {'Authorization'  => @user.authentication_token,
                    'Accept-Version' => 'v1'}

      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)['data']['properties'].size).to eq(5)
    end
    it "should returns 200 with valid params when succes get filter price (5)" do
      get "/properties",
          params:  {q: 5},
          headers: {'Authorization'  => @user.authentication_token,
                    'Accept-Version' => 'v1'}

      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)['data']['properties'].size).to eq(5)
    end
    it "should returns 200 with valid params when succes get filter tags (#lima)" do
      get "/properties",
          params:  {q: "#lima"},
          headers: {'Authorization'  => @user.authentication_token,
                    'Accept-Version' => 'v1'}

      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)['data']['properties'].size).to eq(3)
    end

    it "should returns 200 with valid params when succes get filter sort_by_published ASC first < last " do
      get "/properties",
          params:  {sort_by_published: "ASC"},
          headers: {'Authorization'  => @user.authentication_token,
                    'Accept-Version' => 'v1'}

      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)['data']['properties'].size).to eq(5)
      expect(JSON.parse(response.body)['data']['properties'].first['pubished_at'].to_time.to_i).to be < JSON.parse(response.body)['data']['properties'].last['pubished_at'].to_time.to_i
    end

    it "should returns 200 with valid params when succes get filter sort_by_published DESC first > last " do
      get "/properties",
          params:  {q: "Bima", sort_by_published: "DESC"},
          headers: {'Authorization'  => @user.authentication_token,
                    'Accept-Version' => 'v1'}

      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)['data']['properties'].size).to eq(3)
      expect(JSON.parse(response.body)['data']['properties'].first['pubished_at'].to_time.to_i).to be > JSON.parse(response.body)['data']['properties'].last['pubished_at'].to_time.to_i
    end
  end
end

