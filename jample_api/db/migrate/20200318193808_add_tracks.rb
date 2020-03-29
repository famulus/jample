class AddTracks < ActiveRecord::Migration[6.0]
  def change

    create_table :tracks, id: :uuid do |t|
      
      enable_extension 'pgcrypto'
      enable_extension 'hstore'


      t.timestamps
      t.string :path_and_file
      t.string :file_contents_hash
      t.string :mp3_data_string
      t.string :path_and_file_old
      t.string :title
      t.string :artist
      t.string :album
      t.string :tracknum
      t.string :year
      t.string :comments
      t.string :genre_s
      t.string :youtube_url

      t.integer :onset_count
      t.boolean :track_missing, {null: false, default: false}
      t.text :onset_times, array: true, default: []
      t.hstore :mp3_tag, default: {}, null: false
    

    end
      add_index :tracks, :track_missing
      add_index :tracks, :path_and_file
      add_index :tracks, :file_contents_hash
  end
end
















