# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
r = JSON.parse Faraday.get('https://api.mixin.one/network/assets/top?kind=NORMAL').body
r['data'].each do |asset|
  Tag.find_or_create_by name: asset['symbol']
end
