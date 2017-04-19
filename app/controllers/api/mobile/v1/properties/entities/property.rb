class API::Mobile::V1::Properties::Entities::Property < Grape::Entity
  expose :id
  expose :property_category
  expose :price
  expose :description
end

