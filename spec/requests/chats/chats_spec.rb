require 'rails_helper'

RSpec.describe "Api::V1::Chats", type: :request do
  describe "[POST] Endpoint /private" do
    before :each do
      @user  = FactoryGirl.create(:user)
      @user2 = FactoryGirl.create(:user_2)
      @user3 = FactoryGirl.create(:user_3)

      @chat          = FactoryGirl.create(:chat, chat_type: 1)
      @member_chat_1 = FactoryGirl.create(:member_chat, user: @user2, chat: @chat)
      @member_chat_2 = FactoryGirl.create(:member_chat, user: @user3, chat: @chat)

      @property = FactoryGirl.create(:property, user_id: @user.id, tag_list: "satu, dua, tiga")
    end
    it "should returns 200 with valid params when success get channel" do
      params = {
        channel: @user2.channel,
      }
      post "/chats/private",
           params:  params,
           headers: {'Authorization'  => @user.authentication_token,
                     'Accept-Version' => 'v1'}

      expect(response.status).to eq(201)
      chat = Chat.last
      expect(JSON.parse(response.body)['data']['chat']['channel']).to eq(chat.channel)
      expect(JSON.parse(response.body)['data']['chat']['chat_type']).to eq("private_chat")
      expect(chat.member_chats.size).to eq(2)
      expect(chat.member_chats.pluck(:user_id).include?(@user.id)).to eq(true)
      expect(chat.member_chats.pluck(:user_id).include?(@user2.id)).to eq(true)
    end
    it "should returns 422 with not valid params when fail get channel" do
      params = {
        channel: @user.channel,
      }
      post "/chats/private",
           params:  params,
           headers: {'Authorization'  => @user.authentication_token,
                     'Accept-Version' => 'v1'}
      expect(response.status).to eq(422)
      expect(JSON.parse(response.body)["error"]["errors"]).to eq(["User already on chat"])
    end
    it "should returns 422 with not valid params when fail get channel" do
      params = {
        channel: "1234567890",
      }
      post "/chats/private",
           params:  params,
           headers: {'Authorization'  => @user.authentication_token,
                     'Accept-Version' => 'v1'}

      expect(response.status).to eq(422)
      expect(JSON.parse(response.body)["error"]["errors"]).to eq(["User can't be blank"])
    end
    it "should returns success when channel sudah ada" do
      params = {
        channel: @user3.channel,
      }
      post "/chats/private",
           params:  params,
           headers: {'Authorization'  => @user2.authentication_token,
                     'Accept-Version' => 'v1'}

      expect(response.status).to eq(201)
    end
  end
  describe "[GET] Endpoint /chats" do
    before :each do
      @user     = FactoryGirl.create(:user)
      @user2    = FactoryGirl.create(:user_2)
      @user3    = FactoryGirl.create(:user_3)
      @private  = FactoryGirl.create(:chat, channel: "p_1234567890")
      @private2 = FactoryGirl.create(:chat, channel: "p_0987654321")
      FactoryGirl.create(:member_chat, chat: @private, user: @user)
      FactoryGirl.create(:member_chat, chat: @private, user: @user3)
      FactoryGirl.create(:member_chat, chat: @private2, user: @user)
      FactoryGirl.create(:member_chat, chat: @private2, user: @user2)
    end
    it "should returns 200 with valid params when success get chat" do
      get "/chats",
          headers: {'Authorization'  => @user.authentication_token,
                    'Accept-Version' => 'v1'}

      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)['data']['chats'].size).to eq(2)
      expect(JSON.parse(response.body)['data']['chats'].pluck("chat_type")).to eq(["private_chat", "private_chat"])
    end
  end
end

