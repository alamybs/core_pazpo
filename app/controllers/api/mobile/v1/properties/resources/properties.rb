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
          id:    Property::property_category_ids[key],
          title: key
        }
      end
      present :property_categories, categories, with: API::Mobile::V1::Properties::Entities::PropertyCategory
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
      requires :property_type, type: Integer, default: 1, values: [1, 2], desc: '{ WTB: 1, WTS: 2}'
    end
    post "" do
      error!("401 Unauthorized", 401) unless authenticated_user
      property                      = me.properties.new
      property.description          = params.description
      property.property_category_id = params.property_category_id
      property.property_type        = params.property_type
      property.price                = Property.reformat_price(params.price)
      unless property.save
        error!(property.errors.full_messages.join(", "), 422)
      end
      present :property, property, with: API::Mobile::V1::Properties::Entities::Property
    end

    desc "Update Property" do
      headers "Authorization" => {
        description: "Token User",
        required:    true
      }
    end
    params do
      requires :id, type: String
      requires :price, type: String
      requires :description, type: String
      requires :property_category_id, type: Integer, default: 1, values: [1, 2, 3, 4, 5, 6], desc: '{ Rumah: 1, Ruko: 2, Apartemen: 3, Gudang:4, Kantor: 5, Tanah: 6}'
      requires :property_type, type: Integer, default: 1, values: [1, 2], desc: '{ WTB: 1, WTS: 2}'
    end
    put "/" do
      error!("401 Unauthorized", 401) unless authenticated_user
      property = me.properties.find_by(id: params.id)
      error!("Can't find property by id : #{params.id}", 401) unless property
      property.description          = params.description
      property.property_category_id = params.property_category_id
      property.property_type        = params.property_type
      property.price                = Property.reformat_price(params.price)
      unless property.save
        error!(property.errors.full_messages.join(", "), 422)
      end
      present :property, property, with: API::Mobile::V1::Properties::Entities::Property
    end

    desc "Get current Properties" do
      headers "Authorization" => {
        description: "Token User",
        required:    true
      }
    end
    get "current" do
      error!("401 Unauthorized", 401) unless authenticated_user
      properties = me.properties
      present :properties, properties, with: API::Mobile::V1::Properties::Entities::Property
    end

    desc "Get Property by id" do
      headers "Authorization" => {
        description: "Token User",
        required:    true
      }
    end
    params do
      requires :id, type: String
    end
    get "/:id" do
      error!("401 Unauthorized", 401) unless authenticated_user
      property = Property.find_by(id: params.id)
      error!("Can't find property by id : #{params.id}", 401) unless property
      present :property, property, with: API::Mobile::V1::Properties::Entities::Property
    end

    desc "Delete Property by id" do
      headers "Authorization" => {
        description: "Token User",
        required:    true
      }
    end
    params do
      requires :id, type: String
    end
    delete "" do
      status 200
      error!("401 Unauthorized", 401) unless authenticated_user
      property = me.properties.find_by(id: params.id)
      if property
        error!("Can't destroy property with id : #{params.id}", 401) unless property.destroy
        messages = "Success destroy property with id : #{property.id}."
      else
        messages = "No record found"
        error!("Nothing to do.", 422)
      end
      {messages: messages}
    end

    desc "Get List Properties" do
      headers "Authorization" => {
        description: "Token User",
        required:    true
      }
    end
    params do
      optional :property_category, type: Integer, values: [1, 2, 3, 4, 5, 6], desc: '{ Rumah: 1, Ruko: 2, Apartemen: 3, Gudang:4, Kantor: 5, Tanah: 6}'
      optional :property_type, type: Integer, values: [1, 2], desc: '{WTB: 1, WTS: 2}'
      optional :on_networks, type: Boolean, default: false, desc: '{ All: false, on network: true}'
      optional :sort_by_published, type: String, values: ["ASC", "DESC"], desc: '{ baru -> lama: DESC, lama -> baru: ASC}'
      optional :sort_by_price, type: String, values: ["ASC", "DESC"], desc: '{ mahal -> murah: DESC, murah -> mahal: ASC}'
    end
    get "" do
      error!("401 Unauthorized", 401) unless authenticated_user
      properties = Property.all

      if params.property_type.present?
        properties = properties.where(property_type: params.property_type)
      end

      if params.property_category.present?
        properties = properties.where(property_category_id: params.property_category)
      end

      if params.on_networks.present?
        properties = properties.includes(:user).where(users:{id: [me.followings.pluck(:id)]})
      end

      if params.sort_by_published.present?
        properties = properties.reorder("created_at #{params.sort_by_published}")
      end

      if params.sort_by_price.present?
        properties = properties.reorder("price #{params.sort_by_price}")
      end
      present :properties, properties, with: API::Mobile::V1::Properties::Entities::Property
    end
  end
end
