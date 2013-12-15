require_relative 'spec_helper'

describe 'service dispatcher' do
  xit 'should ask user city info when user search 1st time' do
    User.should_receive(:where){[]}
    User.should_receive(:create){User.new}
    ServiceDispatcher.new.enable_to_serve('fromUser').should == false
  end

  xit 'should update user city info when receive city name' do
    xian = City.new(id:1, name:'西安')
    user = User.new

    City.should_receive(:where).with(name:'西安'){[xian]}
    User.any_instance.should_receive(:city_id=).with(1)
    User.any_instance.should_receive(:save)
    service_dispatcher = ServiceDispatcher.new
    service_dispatcher.service(user,'西安').should == '您设置默认城市为：西安'
  end
end