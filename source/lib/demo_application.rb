require 'omniauth'
require 'omniauth/strategies/salesforce'

require 'sinatra'
require 'multi_json'
require 'cgi'

set :root, File.dirname(__FILE__) + '/../'

use Rack::Session::Cookie

OmniAuth.config.full_host = ENV['HOST'] if ENV['HOST']
OmniAuth.config.on_failure do |env|
  puts "#{env['omniauth.error'].class.to_s}: #{env['omniauth.error'].message}"
  env['omniauth.error'].backtrace.each{|b| puts b}
  puts env['omniauth.error'].response.inspect if env['omniauth.error'].respond_to?(:response)

  [302, {'Location' => '/auth/failure'}, ['302 Redirect']]
end

use OmniAuth::Builder do
  provider :salesforce, ENV['SALESFORCE_KEY'], ENV['SALESFORCE_SECRET']
end

get '/' do
  redirect '/accounts' and return if session.key?(:credentials)
  erb :home
end

get '/auth/salesforce/callback' do
  content_type 'text/plain'
  session[:credentials] = env['omniauth.auth']['credentials']
  redirect '/accounts'
end

get '/auth/failure' do
  erb :fail
end

def client
  OAuth2::Client.new(
    ENV['SALESFORCE_KEY'],
    ENV['SALESFORCE_SECRET'],
    :site => session[:credentials]['instance_url']
  )
end

def access_token
  OAuth2::AccessToken.new(client, session[:credentials]['token'])
end

get '/accounts' do
  response = access_token.get("/services/data/v20.0/query/?q=#{CGI::escape('SELECT Name, Id from Account LIMIT 100')}")
  puts response
  @accounts = MultiJson.decode(response)['records']
  erb :accounts
end

get '/logout' do
  request.env['rack.session'] = {}
  redirect '/'
end
