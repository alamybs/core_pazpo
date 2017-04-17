module API
  module Mobile
    module V1
      module HelloWorlds
        class Routes < Grape::API
          mount API::Mobile::V1::HelloWorlds::Resources::HelloWorlds
        end
      end
    end
  end
end
