Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'localhost:7474'
    resource 'localhost:7474', headers: :any, methods: [:get, :post, :patch, :put]
  end
end
