module API
  module Mobile
    module V1
      module ErrorFormatter
        def self.call data, backtrace, options, env
          begin
            data = {message: data[:message], code: data[:code], backtrace: data[:backtrace]}
          rescue
            code = env['api.endpoint'].status
            data = {message: data, code: code, backtrace: backtrace || []}
          end

          if ENV['API_DEBUGGING'].eql?("true")
            response = {debug: [data[:backtrace]]}
          else
            response = {}
          end
          {
            error: response.merge(code:    data[:code],
                                  message: Rack::Utils::HTTP_STATUS_CODES[data[:code]],
                                  errors:  [data[:message]])
          }.to_json
        end
      end
    end
  end
end