# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2025_10_31_182043) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "hstore"
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pgcrypto"

  create_table "auditions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.integer "start_onset_index"
    t.string "start_onset_time"
    t.integer "stop_onset_index"
    t.string "stop_onset_time"
    t.uuid "track_id"
    t.datetime "updated_at", precision: nil, null: false
    t.uuid "voice_id"
    t.integer "voiced_count"
  end

  create_table "current_patches", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "patch_index"
    t.string "patch_set_id"
    t.string "subset_search_string"
  end

  create_table "filter_history", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
  end

  create_table "patch_sets", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
  end

  create_table "patches", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.uuid "patch_set_id", null: false
    t.datetime "updated_at", null: false
    t.index ["patch_set_id", "created_at"], name: "index_patches_on_patch_set_id_and_created_at"
    t.index ["patch_set_id"], name: "index_patches_on_patch_set_id"
  end

  create_table "tracks", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "album"
    t.string "artist"
    t.string "comments"
    t.datetime "created_at", null: false
    t.string "file_contents_hash"
    t.string "genre_s"
    t.string "mp3_data_string"
    t.hstore "mp3_tag", default: {}, null: false
    t.integer "onset_count"
    t.text "onset_times", default: [], array: true
    t.string "path_and_file"
    t.string "path_and_file_old"
    t.string "title"
    t.boolean "track_missing"
    t.string "tracknum"
    t.datetime "updated_at", null: false
    t.string "year"
    t.string "youtube_url"
    t.boolean "{:null=>false, :default=>false}"
    t.index ["file_contents_hash"], name: "index_tracks_on_file_contents_hash"
    t.index ["path_and_file"], name: "index_tracks_on_path_and_file"
    t.index ["track_missing"], name: "index_tracks_on_track_missing"
  end

  create_table "voices", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.uuid "current_audition_id"
    t.string "max_for_live_voice_id"
    t.uuid "next_audition_id"
    t.uuid "previous_audition_id"
    t.integer "start_onset_index"
    t.string "start_onset_time"
    t.integer "stop_onset_index"
    t.string "stop_onset_time"
    t.uuid "track_id"
    t.datetime "updated_at", precision: nil, null: false
    t.integer "voiced_count"
  end

  add_foreign_key "patches", "patch_sets"
end
