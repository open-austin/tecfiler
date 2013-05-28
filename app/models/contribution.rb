class Contribution < ActiveRecord::Base

  attr_accessible :address, :address2, :city, :contributor_type, :form_type, :name_first, :name_last, 
    :name_suffix, :name_title, :rec_type, :state, :zip

end
