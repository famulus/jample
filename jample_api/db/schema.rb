# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_03_20_194926) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "hstore"
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "auditions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "track_id"
    t.uuid "voice_id"
    t.string "start_onset_time"
    t.string "stop_onset_time"
    t.integer "start_onset_index"
    t.integer "stop_onset_index"
    t.integer "voiced_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "current_patches", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "patch_index"
    t.string "subset_search_string"
    t.string "patch_set_id"
  end

  create_table "tracks", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "path_and_file"
    t.string "file_contents_hash"
    t.string "mp3_data_string"
    t.string "path_and_file_old"
    t.string "title"
    t.string "artist"
    t.string "album"
    t.string "tracknum"
    t.string "year"
    t.string "comments"
    t.string "genre_s"
    t.string "youtube_url"
    t.integer "onset_count"
    t.boolean "track_missing", default: false, null: false
    t.text "onset_times", default: [], array: true
    t.hstore "mp3_tag", default: {}, null: false
    t.index ["file_contents_hash"], name: "index_tracks_on_file_contents_hash"
    t.index ["path_and_file"], name: "index_tracks_on_path_and_file"
    t.index ["track_missing"], name: "index_tracks_on_track_missing"
  end

  create_table "voices", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "max_for_live_voice_id"
    t.uuid "current_audition_id"
    t.uuid "previous_audition_id"
    t.uuid "next_audition_id"
    t.string "start_onset_time"
    t.string "stop_onset_time"
    t.uuid "track_id"
    t.integer "start_onset_index"
    t.integer "stop_onset_index"
    t.integer "voiced_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
