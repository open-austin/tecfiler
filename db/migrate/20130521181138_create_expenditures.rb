class CreateExpenditures < ActiveRecord::Migration
  def change
    create_table :expenditures do |t|
      t.integer :report_id

      t.string :rec_type
      t.string :form_type
      t.string :item_id
      t.string :payee_type
      t.string :payee_name_title
      t.string :payee_name_first
      t.string :payee_name_last
      t.string :payee_name_suffix
      t.string :payee_address, :length => 55
      t.string :payee_address2, :length => 55
      t.string :payee_city, :length => 30
      t.string :payee_state, :length => 2
      t.string :payee_zip, :length => 10
      t.date :date
      t.decimal :amount, :precision => 12, :scale => 2
      t.string :description, :length => 100
      t.boolean :reimbursement_expected
      t.string :candidate_name_title, :length => 15
      t.string :candidate_name_first, :length => 45
      t.string :candidate_name_last, :length => 100
      t.string :candidate_name_suffix, :length => 10
      t.string :office_held_code
      t.string :office_held_description, :length => 30
      t.string :office_held_district, :length => 4
      t.string :office_sought_code
      t.string :office_sought_description, :length => 30
      t.string :office_sought_district, :length => 4
      t.string :backreference_id, :length => 20
      t.boolean :is_corp_contrib
 
      t.timestamps
    end
  end

  def self.down
    drop_table :expenditures
  end

end
