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
end

