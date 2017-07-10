class API::Mobile::V1::ContactBooks::Entities::ContactBook < Grape::Entity
  expose :name
  expose :email
  expose :phone_number
end