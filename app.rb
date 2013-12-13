require 'wei-backend'
require './model/model'
require './lib/ai_bang_client'
require './lib/bus_helper'

on_subscribe do
  CONFIG[:subscribe_message]
end

on_text do
  user = User.where(open_id: params[:FromUserName])
  if user.nil? || user.city.nil?
    User.create(open_id: params[:FromUserName])
    '请告诉我你所在的城市（如，西安），或者给我分享一下您的位置，我好为您继续服务'
  end
  'bus lines'
end

