require 'spec_helper'

describe "contributions/show" do
  before(:each) do
    @contribution = assign(:contribution, stub_model(Contribution,
      :rec_type => "",
      :form_type => "",
      :contributor_type => "",
      :name_title => "Name Title",
      :name_first => "Name First",
      :name_last => "Name Last",
      :name_suffix => "Name Suffix",
      :address => "Address",
      :address2 => "Address2",
      :city => "City",
      :state => "State",
      :zip => "Zip"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
    rendered.should match(//)
    rendered.should match(//)
    rendered.should match(/Name Title/)
    rendered.should match(/Name First/)
    rendered.should match(/Name Last/)
    rendered.should match(/Name Suffix/)
    rendered.should match(/Address/)
    rendered.should match(/Address2/)
    rendered.should match(/City/)
    rendered.should match(/State/)
    rendered.should match(/Zip/)
  end
end
