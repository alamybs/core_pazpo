module API
  module Mobile
    module V1
      module SuccessFormatter
        def self.call object, env
          return {
              :data => object
          }.to_json
        end
      end
    end
  end
end