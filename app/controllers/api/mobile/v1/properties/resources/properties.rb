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

      tags = HastagService.new(params.hastags)
      tags.to_string
      tags.extract

      property.tag_list = tags.results if (params.hastags.present? && tags.results.present?)
      property.price    = Property.reformat_price(params.price)
      unless property.save
        error!(property.errors.full_messages.join(", "), 422)
      end
      present :property, property, with: API::Mobile::V1::Properties::Entities::Property
    end

    desc "Sundul Property" do
      headers "Authorization" => {
        description: "Token User",
        required:    true
      }
    end
    params do
      requires :id, type: String
    end
    put "up" do
      error!("401 Unauthorized", 401) unless authenticated_user
      property = me.properties.find_by(id: params.id)
      error!("Can't find property by id : #{params.id}", 401) unless property
      property.created_at = Time.zone.now
      property.save(validate: false)
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

      tags = HastagService.new(params.hastags)
      tags.to_string
      tags.extract

      property.tag_list = tags.results if (params.hastags.present? && tags.results.present?)
      property.price    = Property.reformat_price(params.price)
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
    paginate per_page: 100, max_per_page: 100
    get "current" do
      error!("401 Unauthorized", 401) unless authenticated_user
      properties = me.properties.order("created_at DESC")
      present :properties, paginate(properties), with: API::Mobile::V1::Properties::Entities::Property
    end

    desc "Get Properties by user_id" do
      headers "Authorization" => {
        description: "Token User",
        required:    true
      }
    end
    params do
      requires :user_id, type: String
    end
    get ":user_id/user" do
      error!("401 Unauthorized", 401) unless authenticated_user
      user = User.find_by(id: params.user_id)
      error!("Can't find user by id : #{params.user_id}", 401) unless user
      properties = user.properties.order("created_at DESC")
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

    desc "Get List Properties" do
      headers "Authorization" => {
        description: "Token User",
        required:    true
      }
    end
    params do
      optional :sort_by_published, type: String, values: ["ASC", "DESC"], desc: '{ baru -> lama: DESC, lama -> baru: ASC}'
      optional :page_type, type: String, default: "Jelajah", values: ["Berita", "Jelajah"], desc: 'type page'
      optional :sort_by_price, type: String, values: ["ASC", "DESC"], desc: '{ mahal -> murah: DESC, murah -> mahal: ASC}'
      optional :q, type: String, desc: 'user name, property description or property price or #jogja #pazpo'
    end
    paginate per_page: 100, max_per_page: 100
    get "" do
      error!("401 Unauthorized", 401) unless authenticated_user
      properties = Property.all
      if params.page_type.downcase.eql?("berita")
        properties = properties.where(id: me.me_and_followings.map {|u| u.properties}.flatten.pluck(:id))
      end
      if params.q.present?
        tags = HastagService.new(params.q)
        tags.to_string
        tags.extract # extract tags from text ["#satu", "#dua"]
        if tags.results.present?
          properties = ActsAsTaggableOn::Tagging.where(taggable_type: "Property", tag_id: ActsAsTaggableOn::Tag.named_like_any(tags.results).pluck(:id)).distinct(:taggable_id)
          properties = properties.map {|p| p.taggable}
        else
          query      = "%#{params.q}%".downcase
          properties = properties.includes(:user).where("(LOWER(users.name) LIKE ? )  OR (LOWER(description) LIKE ?) OR (CAST ( price AS varchar ) LIKE ?)", query, query, query).references(:users)
        end
      end
      if params.sort_by_published.present?
        properties = properties.reorder("properties.created_at #{params.sort_by_published}")
      end

      if params.sort_by_price.present?
        properties = properties.reorder("properties.price #{params.sort_by_price}")
      end
      present :properties, paginate(properties), with: API::Mobile::V1::Properties::Entities::Property
    end

  end
end
