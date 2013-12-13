require 'sinatra'
require 'wei-backend'

on_subscribe do
  CONFIG[:subscribe_message]
end

on_text do
  aibang_client = AiBangClient.new CONFIG[:ai_bang_api], CONFIG[:ai_bang_api_key]
  bus_helper = BusHelper.new aibang_client
  bus_helper.bus_lines_running_time(params[:Content])
end

