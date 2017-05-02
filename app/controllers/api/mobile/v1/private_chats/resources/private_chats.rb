class API::Mobile::V1::PrivateChats::Resources::PrivateChats < Grape::API
  include API::Mobile::V1::Config
  resource "private_chats" do
    desc "Get hastags by title" do
      headers "Authorization" => {
        description: "Token User",
        required:    true
      }
    end
    params do
      requires :user_channel, type: String
    end
    get "channel" do
      error!("401 Unauthorized", 401) unless authenticated_user
      private_ch           = me.private_chats.new
      private_ch.member_ch = params.user_channel

      private_ch.save
      present :private_chat, private_ch, with: API::Mobile::V1::PrivateChats::Entities::PrivateChat
    end
  end
end
