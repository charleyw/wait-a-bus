require 'wei-backend'
require './model/model'
require './lib/ai_bang_client'
require './lib/bus_helper'
require './lib/service_dispatcher'

service_dispatcher = ServiceDispatcher.new

on_subscribe do
  CONFIG[:subscribe_message]
end

on_text do
  service_dispatcher.service params[:FromUserName], params[:Content]
end

