class AddAuditions < ActiveRecord::Migration[6.0]
  def change

    create_table :auditions, id: :uuid do |t|
      enable_extension 'pgcrypto'

      t.uuid :track_id
      t.uuid :voice_id
      t.string :start_onset_time
      t.string :stop_onset_time

      t.integer :start_onset_index
      t.integer :stop_onset_index
      t.integer :voiced_count

    end

  end
end
