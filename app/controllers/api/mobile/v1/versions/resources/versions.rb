class API::Mobile::V1::Versions::Resources::Versions < Grape::API
  include API::Mobile::V1::Config
  resource "versions" do
    desc "Request get version app"
    get "info" do
     version = Version.all.last
      present :version, version, with: API::Mobile::V1::Versions::Entities::Version
    end
  end
end
