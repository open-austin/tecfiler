class CreateContributions < ActiveRecord::Migration
  def change
    create_table :contributions do |t|
      t.integer :report_id
      t.integer :filer_id
      
      t.string :rec_type # ContributionType
      t.string :form_type # FormType
      t.string :contributor_type # ContributorType
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
      t.string :out_of_state_pac_id, :limit => 9
      t.date :date
      t.decimal :amount, :precision => 12, :scale => 2
      t.string :in_kind_description, :limit => 100
      t.string :employer, :limit => 60
      t.string :occupation, :limit => 60

      t.timestamps
    end
    
    add_index :contributions, :report_id
    add_index :contributions, :filer_id
    add_index :contributions, [:report_id, :form_type]
  end

  def self.down
    drop_table :contributions
  end

end
