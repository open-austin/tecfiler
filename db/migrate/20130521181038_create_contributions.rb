class CreateContributions < ActiveRecord::Migration
  def change
    create_table :contributions do |t|

      t.string :version

      t.string :rec_type
      t.string :form_type
      t.string :contributor_type
      t.string :name_title
      t.string :name_first
      t.string :name_last
      t.string :name_suffix
      t.string :address
      t.string :address2
      t.string :city
      t.string :state
      t.string :zip

      t.boolean :is_out_of_state_pac
      t.string :pac_id, :length => 9
      t.date :date
      t.decimal :amount, :precision => 12, :scale => 2
      t.string :in_kind_description, :length => 100
      t.string :employer, :length => 60
      t.string :occupation, :length => 60

      t.timestamps
    end
  end

  def self.down
    drop_table :contributions
  end

end
