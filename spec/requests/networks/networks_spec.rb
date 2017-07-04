require 'rails_helper'

RSpec.describe "Api::V1::Networks", type: :request do
  describe "[POST] Endpoint /networks/follow" do
    before :each do
      @user   = FactoryGirl.create(:user)
      @user_2 = FactoryGirl.create(:user_2)
    end
    it "should returns 200 with valid params when success follow user" do
      params = {
        user_id: @user_2.id,
      }
      post "/networks/follow",
           params:  params,
           headers: {'Authorization'  => @user.authentication_token,
                     'Accept-Version' => 'v1'}

      expect(response.status).to eq(201)
      expect(JSON.parse(response.body)['data']).to eq({"messages" => "Success follow user with id : #{@user_2.id}."})
    end
  end
  describe "[DELETE] Endpoint /networks/unfollow" do
    before :each do
      @user   = FactoryGirl.create(:user)
      @user_2 = FactoryGirl.create(:user_2)

      @follow = FactoryGirl.create(:follow, user_id: @user.id, follow_id: @user_2.id)

    end
    it "should returns 200 with valid params when success unfollow user" do
      params = {
        user_id: @user_2.id,
      }
      delete "/networks/unfollow",
             params:  params,
             headers: {'Authorization'  => @user.authentication_token,
                       'Accept-Version' => 'v1'}

      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)['data']).to eq({"messages" => "Success unfollow user with id : #{@user_2.id}."})
    end
  end
  describe "[GET] Endpoint /networks/followers" do
    before :each do
      @user   = FactoryGirl.create(:user)
      @user_2 = FactoryGirl.create(:user_2)
      @user_3 = FactoryGirl.create(:user_3)
      @user_4 = FactoryGirl.create(:user_4)
      @user_5 = FactoryGirl.create(:user_5)

      @follow_2 = FactoryGirl.create(:follow, user_id: @user.id, follow_id: @user_2.id)
      @follow_3 = FactoryGirl.create(:follow, user_id: @user.id, follow_id: @user_3.id)
      @follow_4 = FactoryGirl.create(:follow, user_id: @user_4.id, follow_id: @user.id)
      @follow_5 = FactoryGirl.create(:follow, user_id: @user_5.id, follow_id: @user.id)

    end
    it "should returns 200 with valid params when success list followers" do
      params = {
        user_id: @user.id,
      }
      get "/networks/followers",
             params:  params,
             headers: {'Authorization'  => @user.authentication_token,
                       'Accept-Version' => 'v1'}

      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)['data']['users'].size).to eq(2)
    end
  end
  describe "[GET] Endpoint /networks/followings" do
    before :each do
      @user   = FactoryGirl.create(:user)
      @user_2 = FactoryGirl.create(:user_2)
      @user_3 = FactoryGirl.create(:user_3)
      @user_4 = FactoryGirl.create(:user_4)
      @user_5 = FactoryGirl.create(:user_5)

      @follow_2 = FactoryGirl.create(:follow, user_id: @user.id, follow_id: @user_2.id)
      @follow_3 = FactoryGirl.create(:follow, user_id: @user.id, follow_id: @user_3.id)
      @follow_4 = FactoryGirl.create(:follow, user_id: @user.id, follow_id: @user_4.id)
      @follow_5 = FactoryGirl.create(:follow, user_id: @user_5.id, follow_id: @user.id)

    end
    it "should returns 200 with valid params when success list followings" do
      params = {
        user_id: @user.id,
      }
      get "/networks/followings",
             params:  params,
             headers: {'Authorization'  => @user.authentication_token,
                       'Accept-Version' => 'v1'}

      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)['data']['users'].size).to eq(3)
    end
  end
end

