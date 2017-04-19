class AccountKit
  require 'net/http'

  def initialize(args = {})
    @authorization_code = ""
    @access_token       = {}
    @success            = nil
    @users              = {}
    @errors             = []
  end

  def authorization_code=(value)
    @authorization_code = value
  end

  def authorization_code
    @authorization_code
  end

  def user
    @users
  end

  def errors
    @errors
  end

  def error?
    @errors.present?
  end

  def access_user
    if :access_token
      params       = {
        access_token: @access_token,
      }
      uri          = URI.parse("https://graph.accountkit.com/v1.2/me/?access_token=#{params[:access_token]}")
      http         = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      request      = Net::HTTP::Get.new(uri)
      response     = http.request(request)
      if response.code.eql?("200")
        @users   = JSON.parse(response.body)
        @success = true
      else
        @success = false
        @errors << JSON.parse(response.body)
      end
      @success
    end
  end

  def access_token
    params       = {
      authorization_code: @authorization_code,
      facebook_app_id:    $fb[:facebook_app_id],
      app_secret:         $fb[:facebook_app_secret]
    }
    uri          = URI.parse("https://graph.accountkit.com/v1.2/access_token?grant_type=authorization_code&code=#{params[:authorization_code]}&access_token=AA|#{params[:facebook_app_id]}|#{params[:app_secret]}")
    http         = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request      = Net::HTTP::Get.new(uri)
    response     = http.request(request)
    if response.code.eql?("200")
      @access_token = JSON.parse(response.body)
      @success      = true
    else
      @success = false
      @errors << JSON.parse(response.body)
    end
    @success
  end
end