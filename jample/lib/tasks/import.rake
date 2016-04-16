require 'shellwords'

task :open_jample => :environment do
	command = ("open /Users/clean/Documents/essample/pure_data/jample.pd")
	puts `#{command}`

	command = ('open /Applications/Google\ Chrome.app "http://localhost"')
	puts `#{command}`

	command = ("cd ~/Documents/essample/jample/;rvmsudo rails server -p 80")
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
	destination_folder = '/Volumes/Samples/facesvases\ samples'
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







