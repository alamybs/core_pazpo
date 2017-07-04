module API
  module Mobile
    module V1
      module Versions
        class Routes < Grape::API
          mount API::Mobile::V1::Versions::Resources::Versions
        end
      end
    end
  end
end
