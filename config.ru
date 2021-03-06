require './init'
require './app'
require './web-app'

ENV['RACK_ENV'] ||= development

root_dir = File.dirname(__FILE__)

set :environment, ENV['RACK_ENV'].to_sym
set :root,        root_dir
set :app_file,    File.join(root_dir, 'web-app.rb')
disable :run

run Sinatra::Application
