puts "okok"

require 'mustache'


# afconvert --file WAVE --data LEI16 /Users/clean/Downloads/take_5.m4a

`aubiocut -i /Users/clean/Downloads/take_5.wav  -Lc`


giada = File.read("giada.mustache")

home_keys = "qwertyuiop[]asdfghjkl;'zxcvbnm,./QWERTYUIOP{}|ASDFGHJKL:\"ZXCVBNM<>?"

home_keys_array = home_keys.bytes.to_a


home = "/Users/clean/Desktop/slices/"

files = %w(
piano.000.35200..wav
piano.001.07733..wav
piano.002.05333..wav
piano.002.41600..wav
piano.002.74133..wav
piano.003.80267..wav
)

puts files

channels = files.each_with_index.map { |f,i| {file_path: "#{f}", channel_index:i, channel_letter: (home_keys_array[i]) }}

new_giada =  Mustache.render(giada, {channels: channels, channel_count: channels.size}  )


File.write("#{home}new_giada.gptc",new_giada )
