class Notifier
  def initialize(args = {})
    args       = args.symbolize_keys
    @message   = args.fetch(:message) if args[:message]
    @data      = args.fetch(:data) if args[:data]
    @recipient = args.fetch(:recipient) if args[:recipient] || []
    @event     = args.fetch(:event) if args[:event]
    # friend_join, weakly_news, follower_info
  end

  def message=(value)
    @message = value
  end

  def message
    @message
  end

  def recipient=(value)
    @recipient = value
  end

  def recipient
    @recipient
  end

  def data=(value)
    @data = value
  end

  def data
    @data
  end

  def event=(value)
    @event = value
  end

  def event
    @event
  end

end
