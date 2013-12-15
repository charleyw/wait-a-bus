class BusHelper
  def initialize(ai_bang_client)
    @ai_bang_client = ai_bang_client
  end

  def bus_lines_running_time(query)
    lines = query.scan(/\w*\d+/)
    bus_num = lines[0].strip if lines.length > 0
    city = query.sub(/#{bus_num}.*/, '').strip
    city = "西安" if city.empty?
    bus_lines_results = @ai_bang_client.bus_lines(city, bus_num)
    result = ''
    bus_lines_results.each do |line|
      running_time = line["info"].scan(/\d{1,2}[:：]\d{1,2}-{1,2}\d{1,2}[:：]\d{1,2}/)[0]
      result += line["name"] + " " + running_time + "\n\n" if !running_time.nil?
    end
    result
  end

  def bus_lines(city, bus_num)
    results = @ai_bang_client.bus_lines(city, bus_num)
    merged_results = merge_return_lines(results)
    format_results(merged_results)
  end

  def format_results(results)
    formatted_results = []
    formatted_results << {
        :title => "共#{results.length}条公交线路",
        :description => '',
        :picture_url => '',
        :url => ''
    }
    results.collect do |line|
      formatted_results << {
          :title => line['name'],
          :description => line['info'],
          :picture_url => '',
          :url => ''
      }
    end
    formatted_results
  end

  def merge_return_lines(results)
    line_names = []

    results.reject! do |line|
      line_name_without_stat_name = line['name'].scan(/.*(?=\(.*\))/)[0]
      if line_names.include? line_name_without_stat_name
        false
      else
        line_names << line_name_without_stat_name
        true
      end
    end
  end
end