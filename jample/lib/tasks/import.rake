task :import_tracks => :environment do
	Track.import_tracks
end


task :cut_16_patches => :environment do
	Track.cut_16_patches
end


task :order_by_slice_length => :environment do
	Track.order_by_slice_length
end

task :midi_test => :environment do
	Track.midi_test
end

