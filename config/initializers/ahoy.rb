# frozen_string_literal: true

class Ahoy::Store < Ahoy::DatabaseStore
  def track_visit(data)
    data[:ip] = request.headers['Fly-Client-IP'] || request.remote_ip
    data[:region] = request.headers['Fly-Region']
    super(data)
  end
end

# set to true for JavaScript tracking
Ahoy.api = false

# set to true for geocoding (and add the geocoder gem to your Gemfile)
# we recommend configuring local geocoding as well
# see https://github.com/ankane/ahoy#geocoding
Ahoy.geocode = false
