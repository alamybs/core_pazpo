class API::Mobile::V1::Hastags::Entities::Hastag < Grape::Entity
  expose :name, as: :title
  expose :taggings_count, as: :count
end