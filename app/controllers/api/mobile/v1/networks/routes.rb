module API
  module Mobile
    module V1
      module Networks
        class Routes < Grape::API
          mount API::Mobile::V1::Networks::Resources::Networks
        end
      end
    end
  end
end
