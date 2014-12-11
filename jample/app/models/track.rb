class Track
  include Mongoid::Document


  field :path_and_file, type: String

  def self.import_tracks
  	track_list_string = `mdfind -name \.mp3`
  	puts "OKOK"
  	# puts track_list
	tracks_array = track_list_string.split("\n")
  	puts tracks_array.size

  	tracks_array.each do |track_path|
  		puts track_path
  		Track.find_or_create_by(path_and_file: track_path)
  		
  	end

  	
  end
end
