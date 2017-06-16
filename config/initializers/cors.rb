Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    if Rails.env.test? || Rails.env.development?
      origins "*"
    else
      origins "*"
      #origins 'waveofweekend.com', 'www.waveofweekend.com'
    end
    resource '*',
             :headers     => :any,
             :methods     => [:get, :post, :delete, :put],
             :credentials => true,
             :max_age     => 0,
             :expose      => ["X-Total", "X-Page", "X-Per-Page", "X-Total-Pages"]
  end
end