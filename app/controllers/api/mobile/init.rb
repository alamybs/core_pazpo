module API
  module Mobile
    class Init < Grape::API
      mount API::Mobile::V1::Main

      # swagger settings
      GrapeSwaggerRails.options.before_action do |request|
        options = {}
        if URI.parse(request.url).request_uri.split("/")[1].eql?("mobile")
          options[:app] = "mobile"
        end
        if URI.parse(request.url).request_uri.eql?("#{options[:app]}/documentation/v1/")
          options[:version] = "v1"
        else
          options[:version] = "v2"
        end
        GrapeSwaggerRails.options.app_url            = "#{options[:app]}/documentation/#{options[:version]}"
        GrapeSwaggerRails.options.url                = "/doc"
        GrapeSwaggerRails.options.hide_url_input     = true
        GrapeSwaggerRails.options.hide_api_key_input = true
        GrapeSwaggerRails.options.headers            = {'Accept-Version' => "#{options[:version]}"}
      end
    end
  end
end