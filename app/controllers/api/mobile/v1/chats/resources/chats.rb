class API::Mobile::V1::Chats::Resources::Chats < Grape::API
  include API::Mobile::V1::Config
  resource "chats" do
    desc "Request channel" do
      headers "Authorization" => {
        description: "Token User",
        required:    true
      }
    end
    params do
      requires :channels, type: Array[String]
      requires :chat_type, type: Integer
    end
    get "channel" do
      error!("401 Unauthorized", 401) unless authenticated_user
      if params.chat_type.eql?(1) && params.channels.size != 2
        error!("Not valid member for private chat", 422)
      end
      chat           = Chat.new
      chat.chat_type = params.chat_type
      if chat.save
        errors = []
        params.channels.each do |c|
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
  end
end
