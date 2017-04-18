module API
  module Mobile
    module V1
      module Users
        class Routes < Grape::API
          mount API::Mobile::V1::Users::Resources::Users
        end
      end
    end
  end
end
