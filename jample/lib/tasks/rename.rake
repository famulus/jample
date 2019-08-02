require 'shellwords'




task :rename_tracks => :environment do
	destination_folder = '/Volumes/BIG_GUY/jample_songs'
	Track.all.each do |track|
		# track.path_and_file = "#{destination_folder}/#{track_name}"
		puts  (new_path = "#{destination_folder}/#{track.file_contents_hash}")

		if  (File.exists?(track.path_and_file) && track.path_and_file.include?('BIG_GUY'))
		File.rename(track.path_and_file, new_path )
		track.path_and_file = new_path
		track.save
		end



		# track.path_and_file = new_path
		# track.save

		# puts track.path_and_file

		# File.rename()

		# command = ("cp #{ Shellwords.shellescape track.path_and_file} #{destination_folder}")
		# puts command
		# begin
		# 	puts `#{command}`
		# rescue Exception => e
		# 	puts "ERROR:#{e}"
		# end
	end

end


task :add_mp3_extension => :environment do
	destination_folder = '/Volumes/BIG_GUY/jample_songs'
	Track.all.each do |track|
		
	end

end

task :check_for_file => :environment do
	destination_folder = '/Volumes/BIG_GUY/jample_songs'
	Track.all.each do |track|
		track.path_and_file = (track.path_and_file + ".mp3")
		ap track.path_and_file
		track.save
	end

end







