  include TimeHelpers

  #ONSET_MODE = :beat
  ONSET_MODE =  :onset

  NUDGE_MILLISEC =  3

  class Audition
    include Mongoid::Document
    include Mongoid::Timestamps::Created

    field :track_id, type: String
    field :voice_id, type: String
    field :start_onset_index, type: Integer
    field :stop_onset_index, type: Integer
    field :start_onset_time, type: String
    field :stop_onset_time, type: String
    field :voiced_count, type: Integer

    belongs_to :track, index: true
    belongs_to :voice, index: true

    index({ track_id: 1, start_onset_index: 1, stop_onset_index: 1 }, { unique: false, drop_dups: false })



    def as_json(options)
      super(options.merge({methods: [:start_onset_time,:stop_onset_time]}))
    end


  end
