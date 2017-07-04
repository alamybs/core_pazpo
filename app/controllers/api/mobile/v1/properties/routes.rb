module API
  module Mobile
    module V1
      module Properties
        class Routes < Grape::API
          mount API::Mobile::V1::Properties::Resources::Properties
        end
      end
    end
  end
end
