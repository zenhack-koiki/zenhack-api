namespace 'images' do
  FlickRaw.api_key = ENV['FLICKR_KEY']
  FlickRaw.shared_secret = ENV['FLICKR_SECRET']

  class FlickrAccessor
    EXTRAS = 'geo,url_l,description,tags'
    LAT = 35.331836
    LON = 139.5531174
    RADIUS = 20
    BASE_PARAMS = {
      text: '鎌倉',
      has_geo: 1,
      lat: LAT,
      lon: LON,
      radius: RADIUS,
      radius_units: 'km',
      extras: EXTRAS
    }

    attr_accessor :list, :page

    def initialize
      @page = 1
    end

    def params
      BASE_PARAMS.merge(page: @page)
    end

    def get
      puts "Page: #{@page}"
      @list = flickr.photos.search params
    end

    def print
      @list.each do |photo|
        image_url = photo['url_l']
        next if photo['url_l'].nil?
        lat =  photo['latitude']
        lon =  photo['longitude']
        next if photo['tags'].nil?

        tags =  photo['tags'].split(' ')
        p tags

        base64 = Base64.strict_encode64(RestClient.get(image_url).body)
        json = {"requests" => [
                 {"image" => { "content" => base64 },
                  "features" => [{
                    "type" => "LABEL_DETECTION",
                    "maxResults" => 5
                  }]
                 }]
               }
        cloud_vision_api_key = ENV['CLOUD_VISION_API_KEY']
        url = "https://vision.googleapis.com/v1/images:annotate?key=#{cloud_vision_api_key}"
        response = RestClient.post(url, JSON.generate(json), {content_type: :json, accept: :json})
        data = JSON.parse(response.body)
        tags ||= []
        tags.concat data['responses'][0]['labelAnnotations'].map{|labelAnnotation| labelAnnotation['description']} unless data['responses'][0]['labelAnnotations'].nil?
        p tags
        next if tags.empty?

        image = Image.new(url: image_url, latitude: lat, longitude: lon)
        tags.each { |tag| image.tag_list.add tag }
        image.save
      end
    end
  end

  task flickr: :environment do
    accessor = FlickrAccessor.new
    accessor.get
    accessor.print

    2.upto(accessor.list.pages) do |i|
      accessor.page = i
      accessor.get
      accessor.print
      sleep(1)
    end
  end
end
