require 'spec_helper'

describe "expenditures/new" do
  before(:each) do
    assign(:expenditure, stub_model(Expenditure,
      :rec_type => "",
      :form_type => "",
      :item_id => "MyString",
      :payee_type => "",
      :payee_name_title => "MyString",
      :payee_name_first => "MyString",
      :payee_name_last => "MyString",
      :payee_name_suffix => "MyString"
    ).as_new_record)
  end

  it "renders new expenditure form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", expenditures_path, "post" do
      assert_select "input#expenditure_rec_type[name=?]", "expenditure[rec_type]"
      assert_select "input#expenditure_form_type[name=?]", "expenditure[form_type]"
      assert_select "input#expenditure_item_id[name=?]", "expenditure[item_id]"
      assert_select "input#expenditure_payee_type[name=?]", "expenditure[payee_type]"
      assert_select "input#expenditure_payee_name_title[name=?]", "expenditure[payee_name_title]"
      assert_select "input#expenditure_payee_name_first[name=?]", "expenditure[payee_name_first]"
      assert_select "input#expenditure_payee_name_last[name=?]", "expenditure[payee_name_last]"
      assert_select "input#expenditure_payee_name_suffix[name=?]", "expenditure[payee_name_suffix]"
    end
  end
end
