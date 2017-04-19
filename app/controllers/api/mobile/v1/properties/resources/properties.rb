class API::Mobile::V1::Properties::Resources::Properties < Grape::API
  include API::Mobile::V1::Config
  resource "property_categories" do
    desc "Get Property" do
      headers "Authorization" => {
        description: "Token User",
        required:    true
      }
    end
    get "" do
      error!("401 Unauthorized", 401) unless authenticated_user
      categories = []
      Property::property_category_ids.each_key do |key|
        categories << {
          id: Property::property_category_ids[key],
          title: key
        }
      end
      present categories, with: API::Mobile::V1::Properties::Entities::PropertyCategory
    end
  end
  resource "properties" do
    desc "Create Property" do
      headers "Authorization" => {
        description: "Token User",
        required:    true
      }
    end
    params do
      requires :price, type: String
      requires :description, type: String
      requires :property_category_id, type: Integer, default: 1, values: [1, 2, 3, 4, 5, 6], desc: '{ Rumah: 1, Ruko: 2, Apartemen: 3, Gudang:4, Kantor: 5, Tanah: 6}'
    end
    post "" do
      error!("401 Unauthorized", 401) unless authenticated_user
      property                      = me.properties.new
      property.description          = params.description
      property.property_category_id = params.property_category_id
      property.price                = Property.reformat_price(params.price)
      unless property.save
        error!(property.errors.full_messages.join(", "), 422)
      end
      present property, with: API::Mobile::V1::Properties::Entities::Property
    end
  end
end
