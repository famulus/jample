require 'mustache'
require 'fileutils'


project_root = "/Users/clean/Documents/essample/"
raw_songs = File.join(project_root, 'raw_songs')
slices_folder = File.join(project_root, 'slices')

puts "About to process #{raw_songs}"

FileUtils.rm Dir.glob(File.join(slices_folder,"*"))

# Run aubiocut on each song in raw songs
Dir.foreach(raw_songs) do |raw_song|
	next if raw_song == '.' or raw_song == '..' 
	next unless raw_song.include?("mp3") or raw_song.include?("m4a")
	puts str = "aubiocut -i \"#{File.join(raw_songs, raw_song)}\" -c  --cut-until-nslices=7 -o #{slices_folder}"
	puts `#{str}`
end

# convert spaces to underscore in slice filenames
Dir.glob(File.join(slices_folder,"*")).each do |original_file|
	next if original_file == '.' or original_file == '..' or original_file == '.DS_Store' 
	underscore_file = original_file.gsub(" ","_")
	FileUtils.mv(original_file,underscore_file) rescue nil
end



# load slice filenames into array
files = []
Dir.foreach(slices_folder) do |item|
	next if item == '.' or item == '..' 
	next unless item.include?("wav")
	# do work on real items
	files << item
end

# puts files.shuffle!

pure_data_list = files.map{|f| "#{File.join(slices_folder, f)};"}.join("\n")
File.write(File.join(project_root,'pure_data','tmp','pd_list.txt'),pure_data_list )
