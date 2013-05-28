class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|

      t.integer :filer_id
      t.string :status
      t.string :office_held
      t.string :office_sought
      t.string :report_type
      t.string :status
      t.date :period_begin
      t.date :period_end
      t.date :election_date
      t.string :election_type
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
    add_index :reports, :filer_id
  end

  def self.down
    drop_table :reports
  end

end
