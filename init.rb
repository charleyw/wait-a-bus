require 'wei-backend'
require 'yaml'

CONFIG = YAML.load_file "config/#{ENV['RACK_ENV']}.yml"