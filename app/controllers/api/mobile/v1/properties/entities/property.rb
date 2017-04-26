class API::Mobile::V1::Properties::Entities::Property < Grape::Entity
  expose :id
  expose :property_category
  expose :price
  expose :description
  expose :property_type
  expose :created_at, as: :pubished_at
end

