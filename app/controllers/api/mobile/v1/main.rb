require "grape-swagger"
module API
  module Mobile
    module V1
      class Main < Grape::API
        unless Rails.env.test?
          use Grape::Middleware::Logger, {
            logger: Logger.new(STDERR)
          }
        end
        # mount API::Mobile::V1::HelloWorlds::Routes
        mount API::Mobile::V1::Versions::Routes
        mount API::Mobile::V1::Users::Routes
        mount API::Mobile::V1::Properties::Routes
        mount API::Mobile::V1::Networks::Routes
        mount API::Mobile::V1::Hastags::Routes
        mount API::Mobile::V1::Chats::Routes

        # swagger settings
        options = {version: "v1"}
        add_swagger_documentation(
          api_version:             options[:version],
          doc_version:             options[:version],
          hide_documentation_path: true,
          mount_path:              "documentation/#{options[:version]}/doc",
          hide_format:             true
        )
      end
    end
  end
end