module API
  module Mobile
    module V1
      module Hastags
        class Routes < Grape::API
          mount API::Mobile::V1::Hastags::Resources::Hastags
        end
      end
    end
  end
end
