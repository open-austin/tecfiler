require 'spec_helper'

describe "treasurers/show" do
  before(:each) do
    @treasurer = assign(:treasurer, stub_model(Treasurer,
      :name_prefix => "Name Prefix",
      :name_first => "Name First",
      :name_mi => "Name Mi",
      :name_nick => "Name Nick",
      :name_last => "Name Last",
      :name_suffix => "Name Suffix",
      :address_street => "Address Street",
      :address_suite => "Address Suite",
      :address_city => "Address City",
      :address_state => "Address State",
      :address_zip => "Address Zip",
      :phone => "Phone"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name Prefix/)
    rendered.should match(/Name First/)
    rendered.should match(/Name Mi/)
    rendered.should match(/Name Nick/)
    rendered.should match(/Name Last/)
    rendered.should match(/Name Suffix/)
    rendered.should match(/Address Street/)
    rendered.should match(/Address Suite/)
    rendered.should match(/Address City/)
    rendered.should match(/Address State/)
    rendered.should match(/Address Zip/)
    rendered.should match(/false/)
    rendered.should match(/Phone/)
  end
end
