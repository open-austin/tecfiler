require 'spec_helper'

describe "contributions/new" do
  before(:each) do
    assign(:contribution, stub_model(Contribution,
      :rec_type => "",
      :form_type => "",
      :contributor_type => "",
      :name_title => "MyString",
      :name_first => "MyString",
      :name_last => "MyString",
      :name_suffix => "MyString",
      :address => "MyString",
      :address2 => "MyString",
      :city => "MyString",
      :state => "MyString",
      :zip => "MyString"
    ).as_new_record)
  end

  it "renders new contribution form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", contributions_path, "post" do
      assert_select "input#contribution_rec_type[name=?]", "contribution[rec_type]"
      assert_select "input#contribution_form_type[name=?]", "contribution[form_type]"
      assert_select "input#contribution_contributor_type[name=?]", "contribution[contributor_type]"
      assert_select "input#contribution_name_title[name=?]", "contribution[name_title]"
      assert_select "input#contribution_name_first[name=?]", "contribution[name_first]"
      assert_select "input#contribution_name_last[name=?]", "contribution[name_last]"
      assert_select "input#contribution_name_suffix[name=?]", "contribution[name_suffix]"
      assert_select "input#contribution_address[name=?]", "contribution[address]"
      assert_select "input#contribution_address2[name=?]", "contribution[address2]"
      assert_select "input#contribution_city[name=?]", "contribution[city]"
      assert_select "input#contribution_state[name=?]", "contribution[state]"
      assert_select "input#contribution_zip[name=?]", "contribution[zip]"
    end
  end
end
