class Expenditure < ActiveRecord::Base

  attr_accessible :form_type, :item_id, :payee_name_first, :payee_name_last, :payee_name_suffix, 
    :payee_name_title, :payee_type, :rec_type


end
