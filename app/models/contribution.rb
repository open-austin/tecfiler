class Contribution < ActiveRecord::Base

  belongs_to :report

  attr_accessible :address, :address2, :amount, :city, :contributor_type, :date, 
    :employer, :form_type, :in_kind_description, :is_out_of_state_pac, :name_first, 
    :name_last, :name_suffix, :name_title, :occupation, :pac_id, :rec_type, :state, :zip

  
  validates :rec_type, :presence => true, :inclusion => {:in => ContributionType.values}
  validates :form_type, :presence => true, :inclusion => {:in => FormType.values}
  validates :contributor_type, :presence => true, :inclusion => {:in => ContributorType.values}
    
  validates :name_first, :length => {:maximum => 45}
  validates :name_last, :presence => true, :length => {:maximum => 100}
    
  with_options :if => "contributor_type == ContributorType::INDIVIDUAL" do |c|
    c.validates :name_first, :presence => true
    c.validates :name_title, :length => {:maximum => 25}
    c.validates :name_suffix, :length => {:maximum => 10}
  end
  
  with_options :if => "contributor_type == ContributorType::ENTITY" do |c|
    c.validates :name_title, :length => {:maximum => 0}
    c.validates :name_suffix, :length => {:maximum => 0}
  end

  REQUIRE_CODE_R_ITEMS = true
  
  validates :address, :presence => REQUIRE_CODE_R_ITEMS, :length => {:maximum => 55}
  validates :address2, :length => {:maximum => 55}
  validates :city, :presence => REQUIRE_CODE_R_ITEMS, :length => {:maximum => 30}
  validates :state, :presence => REQUIRE_CODE_R_ITEMS, :length => {:is => 2},
    :format => {:with => /\A[A-Z][A-Z]\z/}
  validates :zip, :presence => REQUIRE_CODE_R_ITEMS, :length => {:maximum => 10},
    :format => {:with => /\A[0-9]{5}(-[0-9]{4})?\z/}

end
