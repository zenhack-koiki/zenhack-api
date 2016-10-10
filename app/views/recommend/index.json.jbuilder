json.array!(@recommends) do |recommend|
  json.extract! recommend, :longitude, :latitude, :url, :spot
end
