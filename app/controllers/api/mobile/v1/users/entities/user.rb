class API::Mobile::V1::Users::Entities::User < Grape::Entity
  expose :id
  expose :name
  expose :email
  expose :channel
  expose :phone_number
  expose :role
  expose :picture
  expose :account_kit_id
  expose :authentication_token
  expose :info
  expose :player_id
end

