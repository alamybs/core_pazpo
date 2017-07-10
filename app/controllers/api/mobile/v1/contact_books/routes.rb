module API
  module Mobile
    module V1
      module ContactBooks
        class Routes < Grape::API
          mount API::Mobile::V1::ContactBooks::Resources::ContactBooks
        end
      end
    end
  end
end
