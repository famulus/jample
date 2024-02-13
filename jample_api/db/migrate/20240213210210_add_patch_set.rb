class AddPatchSet < ActiveRecord::Migration[7.1]
  def change
    create_table :patch_sets, id: :uuid do |t|
    # enable_extension 'pgcrypto'


    end


  end
end
