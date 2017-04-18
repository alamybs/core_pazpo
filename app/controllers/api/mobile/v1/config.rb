module API
  module Mobile
    module V1
      module Config
        extend ActiveSupport::Concern
        included do
          default_format :json
          version "v1", using: :accept_version_header, vendor: 'mnpix'
          format :json
          content_type :json, 'application/json; charset=UTF-8'
          formatter :json, API::Mobile::V1::SuccessFormatter

          rescue_from :all do |e|
            begin
              code = e.status
            rescue
              code = 500
            end
            if e.class.name.eql?("ActiveRecord::RecordNotFound")
              code = 404
            elsif e.class.name.eql?("Grape::Exceptions::ValidationErrors")
              code = 406
            end
            error!({message: e.message, code: code, backtrace: e.backtrace}, code)
          end
          error_formatter :json, API::Mobile::V1::ErrorFormatter

          helpers do
            include ActionController::HttpAuthentication::Token

            def me
              @me
            end

            def token
              token_params_from(headers['Authorization']).shift[1]
            end


            def authenticated_user
              if headers['Authorization']
                @me = User.find_by(authentication_token: token.strip)
              else
                error!("Token not valid!", 422)
              end
            end
          end

          def logger
            Rails.logger
          end
        end
      end
    end
  end
end
