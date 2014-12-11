class Track
  include Mongoid::Document


  field :path_and_file, type: String
  field :file_contents_hash, type: String

  def self.import_tracks
  	track_list_string = `mdfind -name \.mp3`
  	puts "OKOK"
  	# puts track_list
	tracks_array = track_list_string.split("\n")
  	puts tracks_array.size

  	tracks_array.each do |track_path|
  		puts track_path
  		track = Track.find_or_create_by(path_and_file: track_path)
  		track.file_contents_hash = Digest::MD5.file(track_path).hexdigest
  		track.save
  		
  	end

  	
  end
end
