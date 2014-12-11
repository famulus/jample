class Track

  include Mongoid::Document
  field :path_and_file, type: String


  # embeds_many :instruments


end