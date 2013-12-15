require 'rspec'
require 'spec_helper'
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
    search_results.should == [{:title=>"共3条公交线路", :description=>"", :picture_url=>"", :url=>""}, {:title=>"6路(火车站西-怡园路北口)", :description=>"市区线路; 火车站西-怡园路北口   6:00-20:30,怡园路北口—火车站西 6:00-20:30; 1元一票制 普通卡0.5元 学生卡0.3元。", :picture_url=>"", :url=>"http://54.238.207.76/bus/%E8%A5%BF%E5%AE%89/6%E8%B7%AF(%E7%81%AB%E8%BD%A6%E7%AB%99%E8%A5%BF-%E6%80%A1%E5%9B%AD%E8%B7%AF%E5%8C%97%E5%8F%A3)"}, {:title=>"游6(火车站-唐苑)", :description=>"旅游线路; 火车站东广场--唐苑 6:40--19:30; 起步5角，5角进位，全程3.5元。", :picture_url=>"", :url=>"http://54.238.207.76/bus/%E8%A5%BF%E5%AE%89/%E6%B8%B86(%E7%81%AB%E8%BD%A6%E7%AB%99-%E5%94%90%E8%8B%91)"}, {:title=>"机场大巴6号线(彩虹宾馆-咸阳机场)", :description=>"机场:09:00-21:00;彩虹宾馆:07:00-19:00;费用:15元+1元（燃油附加费）/人;", :picture_url=>"", :url=>"http://54.238.207.76/bus/%E8%A5%BF%E5%AE%89/%E6%9C%BA%E5%9C%BA%E5%A4%A7%E5%B7%B46%E5%8F%B7%E7%BA%BF(%E5%BD%A9%E8%99%B9%E5%AE%BE%E9%A6%86-%E5%92%B8%E9%98%B3%E6%9C%BA%E5%9C%BA)"}]
  end

  it 'should merge return lines when there are return lines in results' do
    results = @response_json['lines']['line']

    merged_results = @bus_helper.merge_return_lines(results)
    merged_results.length.should == 3
    merged_results[0]['name'].should == '6路(火车站西-怡园路北口)'
    merged_results[1]['name'].should == '游6(火车站-唐苑)'
  end

end