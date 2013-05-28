require 'spec_helper'

describe "contributions/index" do
  before(:each) do
    assign(:contributions, [
      stub_model(Contribution,
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
      ),
      stub_model(Contribution,
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
      )
    ])
  end

  it "renders a list of contributions" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "Name Title".to_s, :count => 2
    assert_select "tr>td", :text => "Name First".to_s, :count => 2
    assert_select "tr>td", :text => "Name Last".to_s, :count => 2
    assert_select "tr>td", :text => "Name Suffix".to_s, :count => 2
    assert_select "tr>td", :text => "Address".to_s, :count => 2
    assert_select "tr>td", :text => "Address2".to_s, :count => 2
    assert_select "tr>td", :text => "City".to_s, :count => 2
    assert_select "tr>td", :text => "State".to_s, :count => 2
    assert_select "tr>td", :text => "Zip".to_s, :count => 2
  end
end
