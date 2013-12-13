require 'spec_helper'

describe 'app' do
  include Rack::Test::Methods

  it 'should ask user city info when user search 1st time' do
    post '/', TEXT_MESSAGE_REQUEST, 'CONTENT_TYPE' => 'text/xml'

    last_response.body.should include '<ToUserName><![CDATA[fromUser]]></ToUserName>'
    last_response.body.should include '<Content><![CDATA[请告诉我你所在的城市（如，西安），或者给我分享一下您的位置，我好为您继续服务]]></Content>'
  end

  it 'should save user when user search 1st time' do
    User.should_receive(:where).with({open_id: 'fromUser'}){nil}
    User.should_receive(:create).with(open_id: 'fromUser')

    post '/', TEXT_MESSAGE_REQUEST, 'CONTENT_TYPE' => 'text/xml'
  end

  it 'should ask user info when user has not set city info' do
    user = User.new
    user.open_id = 'test'
    User.should_receive(:where).with(open_id: 'fromUser'){user}

    post '/', TEXT_MESSAGE_REQUEST, 'CONTENT_TYPE' => 'text/xml'
    last_response.body.should include '<ToUserName><![CDATA[fromUser]]></ToUserName>'
    last_response.body.should include '<Content><![CDATA[请告诉我你所在的城市（如，西安），或者给我分享一下您的位置，我好为您继续服务]]></Content>'
  end

  it 'should tell user bus line info when user ask for bus line and user already set city' do
    user = User.new
    user.open_id = 'test'
    user.city = 'xian'

    User.should_receive(:where).with(open_id: 'fromUser'){user}

    post '/', TEXT_MESSAGE_REQUEST, 'CONTENT_TYPE' => 'text/xml'
    last_response.body.should include '<ToUserName><![CDATA[fromUser]]></ToUserName>'
    last_response.body.should include '<Content><![CDATA[bus lines]]></Content>'
  end

end

