require 'mustache'
require 'fileutils'


project_root = "/Users/clean/Documents/essample/"
raw_songs = File.join(project_root, 'raw_songs')
slices_folder = File.join(project_root,'pure_data','tmp', 'slices')
metadata_folder = File.join(project_root,'pure_data','tmp', 'metadata')

puts "About to process #{raw_songs}"

# FileUtils.rm Dir.glob(File.join(slices_folder,"*"))

def sanitize_filename(filename)
	filename.gsub(" ","_").gsub('(','').gsub(')','').gsub("\'", '').gsub('&','')
end


# Run aubiocut on each song in raw songs
song_index = []
Dir.mkdir(metadata_folder) rescue nil

songs_already_sliced = Dir.foreach(slices_folder).to_a
songs_in_raw_songs = Dir.foreach(raw_songs).to_a
songs_in_raw_songs_no_ext = songs_in_raw_songs.map{|s| File.basename(sanitize_filename(s), ".*") }

new_and_old_songs =  (songs_already_sliced | songs_in_raw_songs_no_ext)

Dir.foreach(raw_songs) do |raw_song|
	next if raw_song == '.' or raw_song == '..' 
	next unless raw_song.include?("mp3") or raw_song.include?("m4a") or raw_song.include?("wav") # filter to songs with file formats we can use
	underscore_file = sanitize_filename(raw_song)
	underscore_file_no_ext = File.basename(underscore_file, ".*")
	current_song_dir = (File.join(slices_folder,underscore_file_no_ext ))
	Dir.mkdir(current_song_dir) rescue nil
	if !songs_already_sliced.include?(underscore_file_no_ext)
		puts aubiocut_command = "aubiocut -i \"#{File.join(raw_songs, raw_song)}\" -c  --cut-until-nslices=10 -o #{current_song_dir}"
		puts `#{aubiocut_command}`
		# convert spaces to underscore in slice filenames
		Dir.glob(File.join(current_song_dir,"*")).each do |original_file|
			next if original_file == '.' or original_file == '..' or original_file == '.DS_Store' 
			underscore_slice_file = sanitize_filename(original_file)
			FileUtils.mv(original_file,underscore_slice_file) rescue nil
		end
	end

end

all_slices_list = []

new_and_old_songs.each do |current_song|
	next if current_song == '.' or current_song == '..' or current_song == '.DS_Store' 

	current_song_dir = File.join(slices_folder, current_song)

	# load slice filenames into array
	files = []
	Dir.foreach(current_song_dir) do |item|
		next if item == '.' or item == '..' 
		next unless item.include?("wav")
		# do work on real items
		files << item
	end

	# puts files.shuffle!
	files_paths =files.map{|f| "#{File.join(current_song_dir, f)};"}
	pure_data_list = files_paths.join("\n")
	all_slices_list += files_paths 
	meta_filename = (File.join(metadata_folder, "#{current_song}.txt"))
	song_index << meta_filename
	puts meta_filename
	File.write(meta_filename,pure_data_list)
end

## shuffle all slices
# shuffle_list = all_slices_list.shuffle
# shuffle_list = shuffle_list[0..1000]
# shuffle_file = File.join(metadata_folder, "shuffle.txt")
# File.write(shuffle_file,shuffle_list.join("\n"))

## order all slices by filesize, as an experiment
# puts all_slices_list.inspect


shuffle_list = all_slices_list.sort_by{|li|  File.size(li.gsub(';','')).to_i}
puts shuffle_list.map{|li|  File.size(li.gsub(';',''))}
shuffle_list = shuffle_list[0..10000]
shuffle_file = File.join(metadata_folder, "shuffle.txt")
File.write(shuffle_file,shuffle_list.join("\n"))

song_index.unshift(shuffle_file) # add shuffle file to beginning
song_index_contents = song_index.map{|si| "#{si};"}.join("\n")
File.write(File.join(metadata_folder,"song_index.txt"),song_index_contents )





