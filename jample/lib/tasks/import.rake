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
	CurrentPatch.init
	PatchSet.init_16_patches
end



# doc fax 212-460-5002