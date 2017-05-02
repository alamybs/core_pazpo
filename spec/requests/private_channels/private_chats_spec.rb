require 'rails_helper'

RSpec.describe "Api::V1::PrivateChats", type: :request do
  describe "[GET] Endpoint /channel" do
    before :each do
      @user     = FactoryGirl.create(:user)
      @user2    = FactoryGirl.create(:user_2)
      @property = FactoryGirl.create(:property, user_id: @user.id, tag_list: "satu, dua, tiga")
    end
    it "should returns 200 with valid params when success get channel" do
      params = {
        user_channel: @user2.channel,
      }
      get "/private_chats/channel",
          params:  params,
          headers: {'Authorization'  => @user.authentication_token,
                    'Accept-Version' => 'v1'}

      expect(response.status).to eq(200)
      chat = PrivateChat.last
      expect(JSON.parse(response.body)['data']['private_chat']['group_channel']).to eq(chat.group_ch)
      expect(JSON.parse(response.body)['data']['private_chat']['member_channel']).to eq(chat.member_ch)
    end
  end
end

