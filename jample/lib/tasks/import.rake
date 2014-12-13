task :import_tracks => :environment do
	Track.import_tracks
end


task :cut_16_patches => :environment do
	Track.cut_16_patches
end
