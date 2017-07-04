module API
  module Mobile
    module V1
      module Chats
        class Routes < Grape::API
          mount API::Mobile::V1::Chats::Resources::Chats
        end
      end
    end
  end
end
