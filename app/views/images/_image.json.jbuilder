json.extract! image, :id, :url, :latitude, :longitude, :name, :state, :city, :zipcode, :created_at, :updated_at
json.url image_url(image, format: :json)