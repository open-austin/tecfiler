require 'spec_helper'

describe "filers/new" do
  before(:each) do
    assign(:filer, stub_model(Filer,
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
      :phone => "MyString"
    ).as_new_record)
  end

  it "renders new filer form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", filers_path, "post" do
      assert_select "input#filer_name_prefix[name=?]", "filer[name_prefix]"
      assert_select "input#filer_name_first[name=?]", "filer[name_first]"
      assert_select "input#filer_name_mi[name=?]", "filer[name_mi]"
      assert_select "input#filer_name_nick[name=?]", "filer[name_nick]"
      assert_select "input#filer_name_last[name=?]", "filer[name_last]"
      assert_select "input#filer_name_suffix[name=?]", "filer[name_suffix]"
      assert_select "input#filer_address_street[name=?]", "filer[address_street]"
      assert_select "input#filer_address_suite[name=?]", "filer[address_suite]"
      assert_select "input#filer_address_city[name=?]", "filer[address_city]"
      assert_select "input#filer_address_state[name=?]", "filer[address_state]"
      assert_select "input#filer_address_zip[name=?]", "filer[address_zip]"
      assert_select "input#filer_phone[name=?]", "filer[phone]"
    end
  end
end
