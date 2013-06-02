class Contribution < ActiveRecord::Base

  belongs_to :report

  attr_accessible :address, :address2, :amount, :city, :contributor_type, :date, 
    :employer, :form_type, :in_kind_description, :is_out_of_state_pac, :name_first, 
    :name_last, :name_suffix, :name_title, :occupation, :pac_id, :rec_type, :state, :zip


end
