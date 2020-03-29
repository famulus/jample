class AddVoice < ActiveRecord::Migration[6.0]
  def change
    create_table :voices, id: :uuid do |t|
    enable_extension 'pgcrypto'

      t.string :max_for_live_voice_id
      t.uuid :current_audition_id
      t.uuid :previous_audition_id
      t.uuid :next_audition_id
      t.string :start_onset_time
      t.string :stop_onset_time

      t.uuid :track_id
      t.integer :start_onset_index
      t.integer :stop_onset_index
      t.integer :voiced_count          

    end



  end
end
















    





