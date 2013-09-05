class Expenditure < ActiveRecord::Base

  belongs_to :report
  belongs_to :filer

  after_save :update_report_status

  attr_accessible :amount, :backreference_id, :candidate_name_first, :candidate_name_last, 
    :candidate_name_suffix, :candidate_name_title, :date, :description, :form_type, :is_corp_contrib, 
    :item_id, :office_held_code, :office_held_description, :office_held_district, :office_sought_code, 
    :office_sought_description, :office_sought_district, :payee_address, :payee_address2, :payee_city, 
    :payee_name_first, :payee_name_last, :payee_name_suffix, :payee_name_title, :payee_state, 
    :payee_type, :payee_zip, :rec_type, :reimbursement_expected

  def update_report_status
    self.report.data_changed
  end

end
