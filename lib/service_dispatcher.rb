class ServiceDispatcher
  def initialize
    aibang_client = AiBangClient.new CONFIG[:ai_bang_api], CONFIG[:ai_bang_api_key]
    @bus_helper = BusHelper.new aibang_client
  end

  def service(user_name, request)
    user = User.where(open_id: user_name).first
    city = City.where(name: request).first
    return on_set_city(user_name, city) if city
    return '请告诉我你所在的城市（如，西安），我好为您继续服务' unless enable_to_serve(user)
    return on_direction_search(user, places[0], places[1]) if (places = request.split('到').length == 2)
    on_bus_line_search(user, request)
  end

  def on_bus_line_search(user, request)
    city = City.where(id:user.city_id).first
    @bus_helper.bus_lines(city.name, request)
  end

  def on_direction_search(user, from, to)
    # code here
  end

  def on_set_city(user_name, city)
    user = User.where(open_id: user_name).first
    if user.nil?
      user = User.new
      user.open_id = user_name
    end
    user.city_id = city.id
    user.save
    "您设置默认城市为：#{city.name}"
  end

  def enable_to_serve(user)
    return false if user.nil?
    return false if user.city_id.nil?
    true
  end

end