class API::Mobile::V1::Hastags::Resources::Hastags < Grape::API
  include API::Mobile::V1::Config
  resource "hastags" do
    desc "Get hastags by title" do
      headers "Authorization" => {
        description: "Token User",
        required:    true
      }
    end
    params do
      requires :title, type: String
    end
    get "" do
      error!("401 Unauthorized", 401) unless authenticated_user
      hastags = ActsAsTaggableOn::Tag.all
      hastags = hastags.where("LOWER(name) LIKE ?", "%#{params.title.downcase}%").order(taggings_count: :DESC)
      present :hastags, hastags, with: API::Mobile::V1::Hastags::Entities::Hastag
    end
  end
end
