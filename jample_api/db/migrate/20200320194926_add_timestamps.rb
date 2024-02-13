class AddTimestamps < ActiveRecord::Migration[6.0]
  def change
    add_column :voices, :created_at, :datetime, null: false
    add_column :voices, :updated_at, :datetime, null: false

    add_column :auditions, :created_at, :datetime, null: false
    add_column :auditions, :updated_at, :datetime, null: false

  end
end
