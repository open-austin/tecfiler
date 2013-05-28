require 'spec_helper'

describe "treasurers/new" do
  before(:each) do
    assign(:treasurer, stub_model(Treasurer,
      :name_prefix => "MyString",
      :name_first => "MyString",
      :name_mi => "MyString",
      :name_nick => "MyString",
      :name_last => "MyString",
      :name_suffix => "MyString",
      :address_street => "MyString",
      :address_suite => "MyString",
      :address_city => "MyString",
      :address_state => "MyString",
      :address_zip => "MyString",
      :address_changed => false,
      :phone => "MyString"
    ).as_new_record)
  end

  it "renders new treasurer form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", treasurers_path, "post" do
      assert_select "input#treasurer_name_prefix[name=?]", "treasurer[name_prefix]"
      assert_select "input#treasurer_name_first[name=?]", "treasurer[name_first]"
      assert_select "input#treasurer_name_mi[name=?]", "treasurer[name_mi]"
      assert_select "input#treasurer_name_nick[name=?]", "treasurer[name_nick]"
      assert_select "input#treasurer_name_last[name=?]", "treasurer[name_last]"
      assert_select "input#treasurer_name_suffix[name=?]", "treasurer[name_suffix]"
      assert_select "input#treasurer_address_street[name=?]", "treasurer[address_street]"
      assert_select "input#treasurer_address_suite[name=?]", "treasurer[address_suite]"
      assert_select "input#treasurer_address_city[name=?]", "treasurer[address_city]"
      assert_select "input#treasurer_address_state[name=?]", "treasurer[address_state]"
      assert_select "input#treasurer_address_zip[name=?]", "treasurer[address_zip]"
      assert_select "input#treasurer_address_changed[name=?]", "treasurer[address_changed]"
      assert_select "input#treasurer_phone[name=?]", "treasurer[phone]"
    end
  end
end
