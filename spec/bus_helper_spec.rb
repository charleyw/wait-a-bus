require 'rspec'
require_relative '../lib/ai_bang_client'
require_relative '../lib/bus_helper'

describe 'bus helper' do

  response_json = JSON.parse IO.read('spec/fixtures/bus_lines_response.json')
  it "should return bus running time when user search for line 6 running time and city is xi'an" do
    aibang_client = double(AiBangClient, :bus_lines => (response_json)['lines']['line'])
    bus_helper = BusHelper.new aibang_client
    bus_helper.bus_lines_running_time('西安6路').should include "6\u8def(\u706b\u8f66\u7ad9\u897f-\u6021\u56ed\u8def\u5317\u53e3) 6:00-20:30"
  end

  it "should return bus running time when user search for line k700 running time and city is xi'an" do
    aibang_client = double(AiBangClient, :bus_lines => (response_json)['lines']['line'])
    bus_helper = BusHelper.new aibang_client
    bus_helper.bus_lines_running_time('西安k700路').should include "6\u8def(\u706b\u8f66\u7ad9\u897f-\u6021\u56ed\u8def\u5317\u53e3) 6:00-20:30"
  end

  it "should return bus information when user search for line k700 running time and city is xi'an" do
    aibang_client = double(AiBangClient, :bus_lines => (response_json)['lines']['line'])
    expected = (response_json)['lines']['line'].collect do |line|
      {
          :title => line['name'],
          :description => '',
          :picture_url => '',
          :url => ''
      }
    end
    bus_helper = BusHelper.new aibang_client
    bus_helper.bus_lines('西安','6').length.should >= 2
    bus_helper.bus_lines('西安','6').should == [{:title=>"6路(怡园路北口-火车站西)", :description=>"", :picture_url=>"", :url=>""}, {:title=>"6路(火车站西-怡园路北口)", :description=>"", :picture_url=>"", :url=>""}, {:title=>"游6(唐苑-火车站)", :description=>"", :picture_url=>"", :url=>""}, {:title=>"游6(火车站-唐苑)", :description=>"", :picture_url=>"", :url=>""}, {:title=>"机场大巴6号线(咸阳机场-彩虹宾馆)", :description=>"", :picture_url=>"", :url=>""}, {:title=>"机场大巴6号线(彩虹宾馆-咸阳机场)", :description=>"", :picture_url=>"", :url=>""}]
  end

end