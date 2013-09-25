class DropReportCsvColumns < ActiveRecord::Migration
  def up
    remove_column :reports, :contribution_csv_file_name
    remove_column :reports, :contribution_csv_content_type
    remove_column :reports, :contribution_csv_file_size
    remove_column :reports, :contribution_csv_updated_at
    remove_column :reports, :expenditure_csv_file_name
    remove_column :reports, :expenditure_csv_content_type
    remove_column :reports, :expenditure_csv_file_size
    remove_column :reports, :expenditure_csv_updated_at
  end

  def down
    add_column :reports, :contribution_csv_file_name, :string
    add_column :reports, :contribution_csv_content_type, :string
    add_column :reports, :contribution_csv_file_size, :integer
    add_column :reports, :contribution_csv_updated_at, :datetime
    add_column :reports, :expenditure_csv_file_name, :string
    add_column :reports, :expenditure_csv_content_type, :string
    add_column :reports, :expenditure_csv_file_size, :integer
    add_column :reports, :expenditure_csv_updated_at, :datetime
  end
end
