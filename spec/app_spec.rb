require 'spec_helper'

describe 'app' do
  include Rack::Test::Methods

  xit 'should ask user city info when user search 1st time' do
    User.should_receive(:where){[]}
    User.should_receive(:create){User.new}

    post '/', TEXT_MESSAGE_REQUEST, 'CONTENT_TYPE' => 'text/xml'

    last_response.body.should include '<ToUserName><![CDATA[fromUser]]></ToUserName>'
    last_response.body.should include '<Content><![CDATA[请告诉我你所在的城市（如，西安），我好为您继续服务]]></Content>'
  end

  xit 'should save user when user search 1st time' do
    User.should_receive(:where).with({open_id: 'fromUser'}){nil}
    User.should_receive(:create).with(open_id: 'fromUser')

    post '/', TEXT_MESSAGE_REQUEST, 'CONTENT_TYPE' => 'text/xml'
  end

  it 'should ask user info when user has not set city info' do
    user = User.new
    user.open_id = 'test'
    User.should_receive(:where).with(open_id: 'fromUser'){[user]}
    User.should_not_receive(:create)

    post '/', TEXT_MESSAGE_REQUEST, 'CONTENT_TYPE' => 'text/xml'
    last_response.body.should include '<ToUserName><![CDATA[fromUser]]></ToUserName>'
    last_response.body.should include '<Content><![CDATA[请告诉我你所在的城市（如，西安），我好为您继续服务]]></Content>'
  end

  xit 'should update city info when user send city info' do
    user = User.new
    user.open_id = 'test'
    User.should_receive(:where).with(open_id: 'fromUser'){[user]}
    User.should_not_receive(:create)
    User.any_instance.should_receive(:save)
    User.any_instance.should_receive(:save)

    post '/', SEND_MY_CITY, 'CONTENT_TYPE' => 'text/xml'
    last_response.body.should include '<ToUserName><![CDATA[fromUser]]></ToUserName>'
    last_response.body.should include '<Content><![CDATA[您设置了默认城市：西安]]></Content>'
  end

  xit 'should tell user bus line info when user ask for bus line and user already set city' do
    user = User.new
    user.open_id = 'test'
    user.city = 'xian'

    mocked_response = [{:title=>"6路(怡园路北口-火车站西)", :description=>"", :picture_url=>"", :url=>""}, {:title=>"6路(火车站西-怡园路北口)", :description=>"", :picture_url=>"", :url=>""}, {:title=>"游6(唐苑-火车站)", :description=>"", :picture_url=>"", :url=>""}, {:title=>"游6(火车站-唐苑)", :description=>"", :picture_url=>"", :url=>""}, {:title=>"机场大巴6号线(咸阳机场-彩虹宾馆)", :description=>"", :picture_url=>"", :url=>""}, {:title=>"机场大巴6号线(彩虹宾馆-咸阳机场)", :description=>"", :picture_url=>"", :url=>""}]
    User.should_receive(:where).with(open_id: 'fromUser'){[user]}
    BusHelper.any_instance.should_receive(:bus_lines).with('xian','this is a test'){mocked_response}

    post '/', TEXT_MESSAGE_REQUEST, 'CONTENT_TYPE' => 'text/xml'
    last_response.body.should include '<ToUserName><![CDATA[fromUser]]></ToUserName>'
    last_response.body.should include '<Title><![CDATA[6路(怡园路北口-火车站西)]]></Title>'
    last_response.body.should include '<Title><![CDATA[6路(火车站西-怡园路北口)]]></Title>'
  end

end

