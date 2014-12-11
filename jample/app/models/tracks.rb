class Track

  include Mongoid::Document
  field :path_and_file, type: String


  # embeds_many :instruments

  def import_tracks
  	# track_list = `mdfind -name \.mp3`
  	puts 'track_list'
  end

end