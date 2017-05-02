module API
  module Mobile
    module V1
      module PrivateChats
        class Routes < Grape::API
          mount API::Mobile::V1::PrivateChats::Resources::PrivateChats
        end
      end
    end
  end
end
