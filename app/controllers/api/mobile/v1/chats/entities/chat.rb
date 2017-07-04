class API::Mobile::V1::Chats::Entities::Chat < Grape::Entity
  expose :chat_type
  expose :channel
  expose :users, using: API::Mobile::V1::Users::Entities::UserProperty
end