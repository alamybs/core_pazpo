class API::Mobile::V1::Users::Entities::UserInfo < Grape::Entity
  expose :id
  expose :name
  expose :email
  expose :picture
  expose :phone_number
  expose :channel
  expose :role
  expose :info
end

