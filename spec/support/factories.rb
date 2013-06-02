FactoryGirl.define do
  
  factory :contribution do
    rec_type ContributionType::RECEIPT
    form_type FormType::A1
    contributor_type ContributorType::INDIVIDUAL
    name_first "Moishe"
    name_last "Howard"
    address "100 Main St"
    city "Austin"
    state "TX"
    zip "78701"
  end
  
end

