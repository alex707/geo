class CityRoutes < Application
  get '/' do
    if params[:name]
      json Geocoder.geocode(params[:name])
    else
      status 404
      json ([])
    end
  end
end
