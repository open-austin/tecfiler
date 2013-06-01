class CreateContributions < ActiveRecord::Migration
  def change
    create_table :contributions do |t|

      t.string :version

      t.string :rec_type # Enum[:RECEIPT, :PLEDGE]
      t.string :form_type # Enum[:A1, :A2, :AJ, :AL, :B1, :B2, :B3, :BJ, :C, :C2, :D]
      t.string :contributor_type # Enum[:INDIVIDUAL, :ENTITY]
      t.string :name_title, :limit => 25
      t.string :name_first, :limit => 45
      t.string :name_last, :limit => 100
      t.string :name_suffix, :limit => 10
      t.string :address, :limit => 55
      t.string :address2, :limit => 55
      t.string :city, :limit => 30
      t.string :state, :limit => 2
      t.string :zip, :limit => 10

      t.boolean :is_out_of_state_pac
      t.string :pac_id, :limit => 9
      t.date :date
      t.decimal :amount, :precision => 12, :scale => 2
      t.string :in_kind_description, :limit => 100
      t.string :employer, :limit => 60
      t.string :occupation, :limit => 60

      t.timestamps
    end
  end

  def self.down
    drop_table :contributions
  end

end
