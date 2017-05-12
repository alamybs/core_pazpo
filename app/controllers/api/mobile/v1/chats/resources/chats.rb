class API::Mobile::V1::Chats::Resources::Chats < Grape::API
  include API::Mobile::V1::Config
  resource "chats" do
    desc "Request private channel" do
      headers "Authorization" => {
        description: "Token User",
        required:    true
      }
    end
    params do
      requires :channel, type: String, desc: "user channel target"
    end
    post "private" do
      error!("401 Unauthorized", 401) unless authenticated_user
      chat           = Chat.new
      chat.chat_type = 1
      channels       = [me.channel]
      channels<< params.channel
      if chat.save
        errors = []
        channels.each do |c|
          member      = chat.member_chats.new
          member.user = User.find_by(channel: c)
          errors << member.errors.full_messages.join(", ") unless member.save
        end
        if Chat.chat_types[chat.chat_type].eql?(1)
          if chat.reload.member_chats.size < 2
            chat.destroy
            error!(errors.uniq.to_sentence, 422)
          end
        end
      else
        error!(chat.errors.full_messages.to_sentence, 422)
      end
      present :chat, chat, with: API::Mobile::V1::Chats::Entities::Chat
    end
    desc "Request get chat list" do
      headers "Authorization" => {
        description: "Token User",
        required:    true
      }
    end
    get "" do
      error!("401 Unauthorized", 401) unless authenticated_user
      chats = me.chats
      present :chats, chats, with: API::Mobile::V1::Chats::Entities::Chat
    end
  end
end
