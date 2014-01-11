require 'mustache'


# afconvert --file WAVE --data LEI16 /Users/clean/Downloads/take_5.m4a

# `aubiocut -i /Users/clean/Downloads/take_5.wav  -Lc`


hydrogen = File.read("hydrogen.mustache")

# home_keys = "qwertyuiop[]asdfghjkl;'zxcvbnm,./QWERTYUIOP{}|ASDFGHJKL:\"ZXCVBNM<>?"

# home_keys_array = home_keys.bytes.to_a


home = "/Users/clean/Desktop/slices/"

files = []

Dir.foreach(home) do |item|
	next if item == '.' or item == '..' 
	next unless item.include?("wav")
	# do work on real items
	files << item
end

puts files

channels = files.each_with_index.map { |f,i| {file_path: "#{f}", channel_index:i }}

new_hydrogen =  Mustache.render(hydrogen, {channels: channels, channel_count: channels.size}  )


File.write("#{home}new_hydrogen.h2song",new_hydrogen )
