class API::Mobile::V1::Users::Entities::UserInfo < Grape::Entity
  expose :id
  expose :name
  expose :email
  expose :phone_number
  expose :role
end
