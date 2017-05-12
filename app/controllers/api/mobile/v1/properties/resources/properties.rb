class API::Mobile::V1::Properties::Resources::Properties < Grape::API
  include API::Mobile::V1::Config
  resource "properties" do
    desc "Create Property" do
      headers "Authorization" => {
        description: "Token User",
        required:    true
      }
    end
    params do
      requires :description, type: String
      requires :price, type: String
      requires :property_type, type: Integer, desc: "1 #dijual, 2 #dicari"
      requires :hastags, type: Array[String], desc: "['satu', 'dua']"
    end
    post "" do
      error!("401 Unauthorized", 401) unless authenticated_user
      property               = me.properties.new
      property.description   = params.description
      property.property_type = params.property_type

      tags                   = HastagService.new(params.hastags)
      tags.to_string
      tags.extract

      property.tag_list = tags.results if (params.hastags.present? && tags.results.present?)
      property.price    = Property.reformat_price(params.price)
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
      requires :description, type: String
      requires :property_type, type: Integer, desc: "1 #dijual, 2 #dicari"
      requires :price, type: String
      requires :hastags, type: Array[String], desc: "[satu, dua]"
    end
    put "/" do
      error!("401 Unauthorized", 401) unless authenticated_user
      property = me.properties.find_by(id: params.id)
      error!("Can't find property by id : #{params.id}", 401) unless property
      property.description   = params.description
      property.property_type = params.property_type

      tags                   = HastagService.new(params.hastags)
      tags.to_string
      tags.extract

      property.tag_list      = tags.results if (params.hastags.present? && tags.results.present?)
      property.price         = Property.reformat_price(params.price)
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
    get "/show" do
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

    # desc "Get List Properties by tag" do
    #   headers "Authorization" => {
    #     description: "Token User",
    #     required:    true
    #   }
    # end
    # params do
    #   requires :hastag, type: String
    # end
    # get "/tag/:hastag" do
    #   error!("401 Unauthorized", 401) unless authenticated_user
    #   properties = ActsAsTaggableOn::Tagging.where(taggable_type: "Property", tag_id: ActsAsTaggableOn::Tag.named_like_any([params.hastag]).pluck(:id)).distinct(:taggable_id)
    #
    #   present :properties, properties, with: API::Mobile::V1::Properties::Entities::Property
    # end

  end
end
