class API::Mobile::V1::Users::Entities::User < Grape::Entity
  expose :id
  expose :name
  expose :email
  expose :phone_number
  expose :role
  expose :authentication_token
end

