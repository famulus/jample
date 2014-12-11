class Track
  include Mongoid::Document


  field :path_and_file, type: String
  field :file_contents_hash, type: String
  field :onset_times, type: Array
  field :onset_count, type: Integer


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
  end

  def detect_onset
    if onset_times.blank?
     aubiocut_command = "aubiocut -i \"#{self.path_and_file}\""

     puts onsets = `#{aubiocut_command}`

     self.onset_times = onsets.split("\n")
     self.onset_count = onset_times.size
     self.save

    end
  end


end
