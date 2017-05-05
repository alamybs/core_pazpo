class API::Mobile::V1::Users::Entities::UserProperty < Grape::Entity
  expose :name
  expose :picture
  expose :channel
  expose :role
end