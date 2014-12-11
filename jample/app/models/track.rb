class Track
  include Mongoid::Document


  field :path_and_file, type: String
  field :file_contents_hash, type: String
  field :onset_times, type: Array

  def self.import_tracks
  	track_list_string = `mdfind -name \.mp3`
  	puts "OKOK"
  	# puts track_list
	tracks_array = track_list_string.split("\n")
  	puts tracks_array.size

  	tracks_array.each do |track_path|
  		puts track_path
  		file_contents_hash = Digest::MD5.file(track_path).hexdigest
  		track = Track.find_or_create_by(file_contents_hash: file_contents_hash)
  		track.path_and_file = track_path
  		track.save
  		track.detect_onset
  		
  	end

  	def detect_onset
		puts aubiocut_command = "aubiocut -i \"#{self.path_and_file}\" -c  --cut-until-nslices=10 -o #{current_song_dir}"

  	end

  	
  end
end
