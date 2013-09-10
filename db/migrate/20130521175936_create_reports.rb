class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      
      t.integer :user_id
      t.integer :filer_id
      t.integer :treasurer_id
      
      ###
      #
      # Fields below are filled in from the Filer
      #

      t.string :coh_name_prefix
      t.string :coh_name_first
      t.string :coh_name_mi
      t.string :coh_name_nick
      t.string :coh_name_last
      t.string :coh_name_suffix
      
      t.string :coh_address_street
      t.string :coh_address_suite
      t.string :coh_address_city
      t.string :coh_address_state
      t.string :coh_address_zip
      t.boolean :coh_address_changed   
         
      t.string :coh_phone
      
      #####
      #
      # Fields below are filled in from the Treasurer
      #
      
      t.string :treasurer_name_prefix
      t.string :treasurer_name_first
      t.string :treasurer_name_mi
      t.string :treasurer_name_nick
      t.string :treasurer_name_last
      t.string :treasurer_name_suffix
      
      t.string :treasurer_address_street
      t.string :treasurer_address_suite
      t.string :treasurer_address_city
      t.string :treasurer_address_state
      t.string :treasurer_address_zip
      t.boolean :treasurer_address_changed     
       
      t.string :treasurer_phone
      
      #####
      #
      # Other report values
      #
      
      t.string :state # placeholder for workflow (e.g. draft, filed, accepted, deleted?)
      t.string :report_type # Enum[:JAN15, :JUL15, :ELECTION_30DAY, :ELECTION_8DAY, :RUNNOFF, :EXCEED_500, :TREASURER_APPT, :FINAL]
      t.date :period_begin
      t.date :period_end
      t.date :election_date
      t.string :election_type # Enum[:PRIMARY, :RUNOFF, :GENERAL, :SPECIAL]
      t.string :office_held
      t.string :office_sought

      t.string :contribution_csv_file_name
      t.string :contribution_csv_content_type
      t.integer :contribution_csv_file_size
      t.datetime :contribution_csv_updated_at

      t.string :expenditure_csv_file_name
      t.string :expenditure_csv_content_type
      t.integer :expenditure_csv_file_size
      t.datetime :expenditure_csv_updated_at

      t.timestamps
    end
        
    add_index :reports, :user_id
    add_index :reports, :filer_id
    add_index :reports, :treasurer_id
  end

  def self.down
    drop_table :reports
  end

end
