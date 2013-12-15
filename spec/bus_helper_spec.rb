require 'rspec'
require_relative '../lib/ai_bang_client'
require_relative '../lib/bus_helper'

describe 'bus helper' do
  before(:each) do
    @response_json = JSON.parse IO.read('spec/fixtures/bus_lines_response.json')
    aibang_client = double(AiBangClient, :bus_lines => (@response_json)['lines']['line'])
    @bus_helper = BusHelper.new aibang_client
  end

  it "should return bus running time when user search for line 6 running time and city is xi'an" do
    @bus_helper.bus_lines_running_time('西安6路').should include "6\u8def(\u706b\u8f66\u7ad9\u897f-\u6021\u56ed\u8def\u5317\u53e3) 6:00-20:30"
  end

  it "should return bus running time when user search for line 6 running time and city is xi'an" do
    @bus_helper.bus_lines_running_time('西安k700路').should include "6\u8def(\u706b\u8f66\u7ad9\u897f-\u6021\u56ed\u8def\u5317\u53e3) 6:00-20:30"
  end

  it "should return all buses information when user search for line 6 running time and city is xi'an" do
    search_results = @bus_helper.bus_lines('西安', '6')
    search_results.length.should >= 2
    search_results.should == [{:title=> '共3条公交线路', :description=> '', :picture_url=> '', :url=> ''},{:title=> '6路(火车站西-怡园路北口)', :description=> '', :picture_url=> '', :url=> ''}, {:title=> '游6(火车站-唐苑)', :description=> '', :picture_url=> '', :url=> ''}, {:title=> '机场大巴6号线(彩虹宾馆-咸阳机场)', :description=>"", :picture_url=>"", :url=> ''}]
  end

  it 'should merge return lines when there are return lines in results' do
    results = @response_json['lines']['line']

    merged_results = @bus_helper.merge_return_lines(results)
    merged_results.length.should == 3
    merged_results[0]['name'].should == '6路(火车站西-怡园路北口)'
    merged_results[1]['name'].should == '游6(火车站-唐苑)'
  end

  it 'should return bus line details info when return only one bus line' do
    response_json = JSON.parse IO.read('spec/fixtures/bus_lines_only_one_line.json')
    aibang_client = double(AiBangClient, :bus_lines => (response_json)['lines']['line'])
    bus_helper = BusHelper.new aibang_client

    search_results = bus_helper.bus_lines('西安', '16')
    search_results.length.should > 3
    search_results[0][:title].should == '16路(火车站西-怡园路北口)'
    search_results[1][:title].should == '火车站西'
  end

end