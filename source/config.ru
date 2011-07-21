$:.push File.dirname(__FILE__) + '/lib'

require 'rubygems'
require 'bundler'

Bundler.setup :default, ENV['RACK_ENV']

require 'omniauth/strategies/salesforce'
require 'demo_application'

run Sinatra::Application
