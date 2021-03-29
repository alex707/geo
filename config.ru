require_relative 'config/environment'

run Rack::URLMap.new(
  '/v1/city' => CityRoutes,
)
