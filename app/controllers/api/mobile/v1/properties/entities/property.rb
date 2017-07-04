class API::Mobile::V1::Properties::Entities::Property < Grape::Entity
  expose :id
  expose :price
  expose :property_type
  expose :description
  expose :tag_list, as: :hastags
  expose :created_at, as: :pubished_at
  expose :user, using: API::Mobile::V1::Users::Entities::UserProperty
end

