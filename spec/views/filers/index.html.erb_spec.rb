require 'spec_helper'

describe "filers/index" do
  before(:each) do
    assign(:filers, [
      stub_model(Filer,
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
        :address_changed => false,
        :phone => "Phone"
      ),
      stub_model(Filer,
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
        :address_changed => false,
        :phone => "Phone"
      )
    ])
  end

  it "renders a list of filers" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name Prefix".to_s, :count => 2
    assert_select "tr>td", :text => "Name First".to_s, :count => 2
    assert_select "tr>td", :text => "Name Mi".to_s, :count => 2
    assert_select "tr>td", :text => "Name Nick".to_s, :count => 2
    assert_select "tr>td", :text => "Name Last".to_s, :count => 2
    assert_select "tr>td", :text => "Name Suffix".to_s, :count => 2
    assert_select "tr>td", :text => "Address Street".to_s, :count => 2
    assert_select "tr>td", :text => "Address Suite".to_s, :count => 2
    assert_select "tr>td", :text => "Address City".to_s, :count => 2
    assert_select "tr>td", :text => "Address State".to_s, :count => 2
    assert_select "tr>td", :text => "Address Zip".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => "Phone".to_s, :count => 2
  end
end
