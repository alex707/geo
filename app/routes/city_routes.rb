class CityRoutes < Application
  namespace '/v1' do
    get do
    	if params[:city]
      	json Geocoder.geocode(params[:city])
      else
      	status 404
      	json ([])
    	end
    end
  end
end
