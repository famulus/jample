class AddCurrentPatch < ActiveRecord::Migration[6.0]
  
  def change
    create_table :current_patches, id: :uuid do |t|
      enable_extension 'pgcrypto'

      t.integer :patch_index
      t.string :subset_search_string
      t.string :patch_set_id

    

    end

  end
end
