module TimeHelpers
  def sec_dot_milli_to_milli(sec_dot_milli)
    raise "Bad second dot millisecond format for #{sec_dot_milli}"  unless /^\d+\.\d+$/.match(sec_dot_milli)
    second = sec_dot_milli.split('.').first.to_i
    millisecond = sec_dot_milli.split('.').last.to_i

    result = (second*10000)+millisecond
    return result
  end

  def convert_time_format(thousandths)
    # convert from thousandths to min.sec.thousands
    raise "thousandths required" if thousandths.blank?
    puts "CONVERT_TIME_FORMAT"
    puts thousandths
    
    sec = thousandths.split(".").first.to_i
    thousandths = thousandths.split(".").last

    min = (sec/60).floor
    sec = sec % 60

    result = "#{min}.#{sec}.#{thousandths[0...2]}"
    puts result
    return result
  end

end