  ONSET_MODE =  :onset

  NUDGE_MILLISEC =  3

  class Audition < ActiveRecord::Base


    belongs_to :track, optional: true,autosave: true
    belongs_to :voice,optional: true,autosave: true
    

    # index({ track_id: 1, start_onset_index: 1, stop_onset_index: 1 }, { unique: false, drop_dups: false })



    def as_json(options)
      super(options.merge({methods: [:start_onset_time,:stop_onset_time]}))
    end


  end
