require 'rails_helper'

RSpec.describe "Api::V1::Chats", type: :request do
  describe "[GET] Endpoint /channel" do
    before :each do
      @user     = FactoryGirl.create(:user)
      @user2    = FactoryGirl.create(:user_2)
      @property = FactoryGirl.create(:property, user_id: @user.id, tag_list: "satu, dua, tiga")
    end
    it "should returns 200 with valid params when success get channel" do
      params = {
        channels: [@user2.channel,@user.channel ],
        chat_type:    1
      }
      get "/chats/channel",
          params:  params,
          headers: {'Authorization'  => @user.authentication_token,
                    'Accept-Version' => 'v1'}

      expect(response.status).to eq(200)
      chat = Chat.last
      expect(JSON.parse(response.body)['data']['chat']['channel']).to eq(chat.channel)
      expect(JSON.parse(response.body)['data']['chat']['chat_type']).to eq("private_chat")
      expect(chat.member_chats.size).to eq(2)
      expect(chat.member_chats.pluck(:user_id).include?(@user.id)).to eq(true)
      expect(chat.member_chats.pluck(:user_id).include?(@user2.id)).to eq(true)
    end
    it "should returns 422 with not valid params when fail get channel" do
      params = {
        channels: [@user2.channel],
        chat_type:    1
      }
      get "/chats/channel",
          params:  params,
          headers: {'Authorization'  => @user.authentication_token,
                    'Accept-Version' => 'v1'}

      expect(response.status).to eq(422)
      expect(JSON.parse(response.body)["error"]["errors"]).to eq(["Not valid member for private chat"])
    end
    it "should returns 422 with not valid params when fail get channel" do
      params = {
        channels: [@user2.channel, "1234567890"],
        chat_type:    1
      }
      get "/chats/channel",
          params:  params,
          headers: {'Authorization'  => @user.authentication_token,
                    'Accept-Version' => 'v1'}

      expect(response.status).to eq(422)
      expect(Chat.first).to eq(nil)
      expect(JSON.parse(response.body)["error"]["errors"]).to eq(["User can't be blank"])
    end
  end
end

