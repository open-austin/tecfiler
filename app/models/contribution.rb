class Contribution < ActiveRecord::Base

  belongs_to :report
  belongs_to :filer
  # XXX - should this: belongs_to :filer

  attr_accessible :address, :address2, :amount, :city, :contributor_type, :date, 
    :employer, :form_type, :in_kind_description, :is_out_of_state_pac, :name_first, 
    :name_last, :name_suffix, :name_title, :occupation, :out_of_state_pac_id, :rec_type, :state, :zip
      
  #
  # Validations based on field definitions in "TX/CFS Import Guide"
  # http://www.ethics.state.tx.us/whatsnew/ImportGuide.pdf
  #

  validates :rec_type, :presence => true, :inclusion => {:in => ContributionType.values}    
  validates :form_type, :presence => true, :inclusion => {:in => FormType.values}
    
  # TODO - Need to validate the rec_type, form_type and filer.filer_type combination.
    
  validates :contributor_type, :presence => true, :inclusion => {:in => ContributorType.values}
  validates :contributor_type,
    :inclusion => {:in => [ContributorType::ENTITY], :message => "must be an ENTITY for the specified form type"},
    :if => "form_type_one_of?(FormType::C, FormType::D)"
    
  validates :name_title, :length => {:maximum => 25}
  validates :name_first, :length => {:maximum => 45}
  validates :name_last, :presence => true, :length => {:maximum => 100}    
  validates :name_suffix, :length => {:maximum => 10}
  with_options :if => "contributor_type == ContributorType::INDIVIDUAL" do |c|
    c.validates :name_first, :presence => true
  end  
  with_options :if => "contributor_type == ContributorType::ENTITY" do |c|
    c.validates :name_title, :blank => true
    c.validates :name_suffix, :blank => true
  end
  
  validates :address, :length => {:maximum => 55}      
  validates :address2, :length => {:maximum => 55}    
  validates :city, :length => {:maximum => 30}
  validates :state, :length => {:maximum => 2}, :format => {:with => /\A[A-Z][A-Z]\z/}
  validates :zip, :length => {:maximum => 10}, :format => {:with => /\A[0-9]{5}(-[0-9]{4})?\z/} 
    
  # XXX document this setting
  REQUIRE_CODE_R_ITEMS = true
  
  with_options :if => "REQUIRE_CODE_R_ITEMS" do |c|  
    c.validates :address, :presence => true
    c.validates :city, :presence => true  
    c.validates :state, :presence => true
    c.validates :zip, :presence => true
  end

  validates :is_out_of_state_pac,
    :inclusion => {:in => [true, false], :message => "must be true or false"}
  validates :is_out_of_state_pac,
    :inclusion => {:in => [false], :message => "cannot be set for given form type"},
    :if => "form_type_one_of?(FormType::AL, FormType::C)"
  
  # XXX - Do we really want to validate format this closely?
  # XXX - Is this field really optional when is_out_of_state_pac is true?
  validates :out_of_state_pac_id,
    :length => {:maximum => 9},
    :format => {:with => /\AC[0-9]{8}\z/}, # derived from dataset inspection, may not be correct
    :allow_blank => true
  validates :out_of_state_pac_id,
    :blank => {:message => "must be empty for given form type"},
    :if => "form_type_one_of?(FormType::AL, FormType::C)"
  validates :out_of_state_pac_id,
    :blank => {:message => "must be empty when \"Out of State PAC\" is not set"},
    :if => "!is_out_of_state_pac"
  
  validates :date, :presence => true
  validates :amount, :presence => true, :numericality => {:greater_than => 0.00, :less_than_or_equal_to => 999999999.99}
  validates :in_kind_description, :length => {:maximum => 100}
    
  validates :employer, :length => {:maximum => 60}
  validates :employer, :presence => true, :if => "form_type_one_of?(FormType::AJ)"
  validates :employer, :blank => true, :if => "form_type_one_of?(FormType::AL, FormType::C)"
  
  validates :occupation, :length => {:maximum => 60}
  validates :occupation, :presence => true, :if => "form_type_one_of?(FormType::A2, FormType::AJ)"
  validates :occupation, :blank => true, :if => "form_type_one_of?(FormType::AL, FormType::C)"

  # Convenience method for validation :if clauses
  def form_type_one_of?(*types)
    types.include?(form_type)
  end
  private :"form_type_one_of?"
  
end
