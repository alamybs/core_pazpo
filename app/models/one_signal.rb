class OneSignal
  def initialize(args = {})
    @notifier = args.fetch(:notifier)
    @success  = nil
    @response = nil
  end

  def notifier
    @notifier
  end

  def response
    @response || "Notification not pushed."
  end

  def push
    params       = {
      app_id:             $push[:app_id],
      headings:           {en: "PAZPO"},
      contents:           {en: @notifier.message},
      data:               {
        event: @notifier.event,
        data:  @notifier.data
      },
      include_player_ids: @notifier.recipient
    }
    uri          = URI.parse('https://onesignal.com/api/v1/notifications')
    http         = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request      = Net::HTTP::Post.new(uri.path,
                                       'Content-Type'  => 'application/json;charset=utf-8',
                                       'Authorization' => "Basic #{$push[:key_id]}")
    request.body = params.as_json.to_json
    response     = http.request(request)
    if response.code.eql?("200")
      puts response.body
      response = []
      @success = true
    else
      @success = false
      response = response.body
      puts response
    end
    @response = response
    @success
  end

  def errors
    if @success.nil?
      @response.blank? ? [] : @response
    else
      @response.blank? ? [] : JSON.parse(@response)
    end
  end
end
