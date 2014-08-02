require 'sinatra'
require 'sinatra/json'
require 'brewery_db'

configure :development do
  require 'dotenv'
  Dotenv.load

  require 'pry'
end

configure do
  set :brewery_api_key, ENV['BREWERY_API']
end

def brewery_db
  BreweryDB::Client.new do |config|
    config.api_key = settings.brewery_api_key
  end
end

get '/' do

  erb :index
end

get '/chart' do

  erb :chart
end

get '/beers' do
  abv = params['abv'] || '25+'
  beers = brewery_db.beers.all(abv: abv, withBreweries: 'Y')

  json beers.to_a
end
