class API::Mobile::V1::Users::Entities::UserProperty < Grape::Entity
  expose :id
  expose :name
  expose :picture
  expose :channel
  expose :role
  expose :info
  expose :player_id
end