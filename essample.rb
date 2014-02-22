require 'mustache'
require 'fileutils'


project_root = "/Users/clean/Documents/essample/"
raw_songs = File.join(project_root, 'raw_songs')
slices_folder = File.join(project_root,'pure_data','tmp', 'slices')
metadata_folder = File.join(project_root,'pure_data','tmp', 'metadata')

puts "About to process #{raw_songs}"

# FileUtils.rm Dir.glob(File.join(slices_folder,"*"))

# Run aubiocut on each song in raw songs
song_index = []
Dir.mkdir(metadata_folder)
Dir.foreach(raw_songs) do |raw_song|
	next if raw_song == '.' or raw_song == '..' 
	next unless raw_song.include?("mp3") or raw_song.include?("m4a")
	underscore_file = raw_song.gsub(" ","_").gsub('(','').gsub(')','')
	underscore_file_no_ext = File.basename(underscore_file, ".*")
	current_song_dir = (File.join(slices_folder,underscore_file_no_ext ))
	Dir.mkdir(current_song_dir) rescue nil
	puts str = "aubiocut -i \"#{File.join(raw_songs, raw_song)}\" -c  --cut-until-nslices=15 -o #{current_song_dir}"
	puts `#{str}`
	# convert spaces to underscore in slice filenames
	Dir.glob(File.join(current_song_dir,"*")).each do |original_file|
		next if original_file == '.' or original_file == '..' or original_file == '.DS_Store' 
		underscore_slice_file = original_file.gsub(" ","_").gsub('(','').gsub(')','')
		FileUtils.mv(original_file,underscore_slice_file) rescue nil
	end


	# load slice filenames into array
	files = []
	Dir.foreach(current_song_dir) do |item|
		next if item == '.' or item == '..' 
		next unless item.include?("wav")
		# do work on real items
		files << item
	end

	# puts files.shuffle!
	pure_data_list = files.map{|f| "#{File.join(current_song_dir, f)};"}.join("\n")
	meta_filename = (File.join(metadata_folder, "#{underscore_file_no_ext}.txt"))
	song_index << meta_filename
	puts "OKOK"
	puts meta_filename
	File.write(meta_filename,pure_data_list)
end
song_index_contents = song_index.map{|si| "#{si};"}.join("\n")
File.write(File.join(metadata_folder,"song_index.txt"),song_index_contents )





