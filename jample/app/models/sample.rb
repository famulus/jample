class Sample
  include Mongoid::Document


  field :track_id, type: String
  field :start_onset_index, type: Integer
  field :stop_onset_index, type: Integer

  belongs_to :track



end
