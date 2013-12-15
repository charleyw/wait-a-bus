require 'sinatra'
require './lib/ai_bang_client'

aibang_client = AiBangClient.new CONFIG[:ai_bang_api], CONFIG[:ai_bang_api_key]

get '/bus/:city/:name' do
  result = aibang_client.bus_lines(params[:city],params[:name])[0]
  haml :bus_line, :locals => {:name => result['name'], :info => result['info'], :stats=>result['stats'].split(';')}
end