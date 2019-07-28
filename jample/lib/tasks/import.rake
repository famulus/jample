require 'shellwords'

task :open_jample => :environment do
	command = ("open /Users/clean/Documents/essample/pure_data/jample.pd")
	puts `#{command}`


	command = ("cd ~/Documents/essample/jample/;rvmsudo rails server -p 80 -d")
	puts `#{command}`

	command = ('open /Applications/Google\ Chrome.app "http://localhost"')
	puts `#{command}`

end

task :import_tracks => :environment do
	Track.import_tracks
end

task :convert_to_mp3 => :environment do
	Dir.glob('/Users/clean/Documents/essample/raw_songs/stems/**/*.ogg') do |file|
		escaped_file = Shellwords.escape(file)
		convert_command = "ffmpeg -i #{escaped_file} #{escaped_file.gsub('ogg', 'mp3')}"
	 	`#{convert_command}`
	end
end


task :init => :environment do
	FileUtils.mkpath( PATCH_DIRECTORY)
	CurrentPatch.create
	PatchSet.init_16_patches
	CurrentPatch.init
end



task :copy_files_to_location => :environment do
	destination_folder = '/Volumes/BIG_GUY/jample_songs'
	Track.all.each do |track|
		command = ("cp #{ Shellwords.shellescape track.path_and_file} #{destination_folder}")
		puts command
		begin
			puts `#{command}`
		rescue Exception => e
			puts "ERROR:#{e}"
		end
	end

end






task :add_mp3_to_all_files => :environment do
	destination_folder = '/Volumes/BIG_GUY/jample_songs'
	Track.all.each do |track|
		starting_path_and_file  = track.path_and_file
		ending_path_and_file  = "#{track.path_and_file}.mp3"
		unless starting_path_and_file.include? ("mp3")
			command = ("mv #{ Shellwords.shellescape starting_path_and_file} #{Shellwords.shellescape ending_path_and_file}")
			puts "\n\n"
			puts starting_path_and_file
			puts ending_path_and_file
			puts `#{command}`
			puts "\n\n"
			track.path_and_file = ending_path_and_file
			track.save
			# puts command
			# begin
			# rescue Exception => e
			# 	puts "ERROR:#{e}"
			# end
		end
	end

end






task :change_file_reference_to_new_location => :environment do
	destination_folder = '/Volumes/BIG_GUY/jample_songs'
	Track.all.each do |track|
		# track.path_and_file = "#{destination_folder}/#{track_name}"
		puts  (new_path = "#{destination_folder}/#{track.track_name}")
		track.path_and_file = new_path
		track.save

		# command = ("cp #{ Shellwords.shellescape track.path_and_file} #{destination_folder}")
		# puts command
		# begin
		# 	puts `#{command}`
		# rescue Exception => e
		# 	puts "ERROR:#{e}"
		# end
	end

end

task :remove_old_file => :environment do
	destination_folder = '/Volumes/BIG_GUY/jample_songs'
	Track.all.each do |track|

		command = ("rm #{ Shellwords.shellescape track.path_and_file_old}")
		puts command
		begin
			puts `#{command}`
		rescue Exception => e
			puts "ERROR:#{e}"
		end
	end

end


task :convert_from_index_to_time => :environment do
	destination_folder = '/Volumes/BIG_GUY/jample_songs'
	Patch.all.each do |patch|
		begin
			patch.start_onset_time  = patch.track.onset_times[patch.start_onset_index]
			patch.stop_onset_time = patch.track.onset_times[patch.stop_onset_index]
			patch.save
		rescue => e
			puts "\n\n BAD TRACK\n\n\n"		
		end
	end

end



task :populate_onset_times_beat_mode => :environment do
	tracks = Track.where({onset_times_beat_mode: nil})
	tracks.each{|t|t.detect_beat()}
end







