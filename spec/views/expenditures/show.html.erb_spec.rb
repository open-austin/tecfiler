require 'spec_helper'

describe "expenditures/show" do
  before(:each) do
    @expenditure = assign(:expenditure, stub_model(Expenditure,
      :rec_type => "",
      :form_type => "",
      :item_id => "Item",
      :payee_type => "",
      :payee_name_title => "Payee Name Title",
      :payee_name_first => "Payee Name First",
      :payee_name_last => "Payee Name Last",
      :payee_name_suffix => "Payee Name Suffix"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
    rendered.should match(//)
    rendered.should match(/Item/)
    rendered.should match(//)
    rendered.should match(/Payee Name Title/)
    rendered.should match(/Payee Name First/)
    rendered.should match(/Payee Name Last/)
    rendered.should match(/Payee Name Suffix/)
  end
end
