require 'mustache'
require 'fileutils'



project_root = "/Users/clean/Documents/essample/"

raw_songs = File.join(project_root, 'raw_songs')
slices_folder = File.join(project_root, 'slices')
hydrogen = File.read(File.join(project_root, "hydrogen.mustache"))


# For each song in raw songs
Dir.foreach(raw_songs) do |raw_song|
	next if raw_song == '.' or raw_song == '..' 
	next unless raw_song.include?("mp3")
	puts str = "aubiocut -i \"#{File.join(raw_songs, raw_song)}\" -c -b --cut-until-nslices=4 -o=#{slices_folder}"
	puts `#{str}`
	# `mv ./*.wav #{slices_folder}`
end




# files = []
# Dir.foreach(slices_folder) do |item|
# 	next if item == '.' or item == '..' 
# 	next unless item.include?("wav")
# 	# do work on real items
# 	files << item
# end

# puts files

# channels = files.each_with_index.map { |f,i| {file_path: "#{f}", channel_index:i }}

# new_hydrogen =  Mustache.render(hydrogen, {channels: channels, channel_count: channels.size}  )


# File.write("#{slices_folder}new_hydrogen.h2song",new_hydrogen )
