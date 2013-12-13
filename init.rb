ENV['RACK_ENV'] ||= 'production'

require 'sinatra'
require 'sinatra/activerecord'
require 'wei-backend'
require 'yaml'

set :database, 'sqlite3:///db/production.db'

CONFIG = YAML.load_file "config/#{ENV['RACK_ENV']}.yml"