class CreateFilers < ActiveRecord::Migration
  def change
    create_table :filers do |t|
      t.integer :user_id
      t.string :version
      t.string :filer_type
      t.string :name_prefix
      t.string :name_first
      t.string :name_mi
      t.string :name_nick
      t.string :name_last
      t.string :name_suffix
      t.string :address_street
      t.string :address_suite
      t.string :address_city
      t.string :address_state
      t.string :address_zip
      t.boolean :address_changed
      t.string :phone

      t.timestamps
    end
    add_index :filers, :user_id
  end

  def self.down
    drop_table :filers
  end

end
