require 'mustache'
require 'fileutils'



project_root = "/Users/clean/Documents/essample/"

raw_songs = File.join(project_root, 'raw_songs')
slices_folder = File.join(project_root, 'slices')
pure_data_template = File.read(File.join(project_root, "pure_data.mustache"))


# FileUtils.rm Dir.glob(File.join(slices_folder,"*"))

# # For each song in raw songs
# Dir.foreach(raw_songs) do |raw_song|
# 	next if raw_song == '.' or raw_song == '..' 
# 	next unless raw_song.include?("mp3")
# 	puts str = "aubiocut -i \"#{File.join(raw_songs, raw_song)}\" -c  --cut-until-nslices=10 -o #{slices_folder}"
# 	puts `#{str}`
# end




files = []
Dir.foreach(slices_folder) do |item|
	next if item == '.' or item == '..' 
	next unless item.include?("wav")
	# do work on real items
	files << item
end

 files.shuffle!
puts files = files[0..20]

file_objects = files.each_with_index.map do |file, i|
	{file: file, index: i, ypos: (i*200), filepath:File.join(slices_folder,file)}	
end

number_of_object_per_channel = 5
run_once_offset = 1

connections= files.each_with_index.map do |file, i|
	{file: file, index: i, from: ((number_of_object_per_channel*i)+1+run_once_offset), to: (number_of_object_per_channel*i+run_once_offset)}	
end


populated_pure_data_template =  Mustache.render(pure_data_template, {file_objects: file_objects, connections:connections}  )


File.write(File.join(project_root,'generated.pd'),populated_pure_data_template )
