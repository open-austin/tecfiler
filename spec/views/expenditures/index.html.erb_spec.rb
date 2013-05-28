require 'spec_helper'

describe "expenditures/index" do
  before(:each) do
    assign(:expenditures, [
      stub_model(Expenditure,
        :rec_type => "",
        :form_type => "",
        :item_id => "Item",
        :payee_type => "",
        :payee_name_title => "Payee Name Title",
        :payee_name_first => "Payee Name First",
        :payee_name_last => "Payee Name Last",
        :payee_name_suffix => "Payee Name Suffix"
      ),
      stub_model(Expenditure,
        :rec_type => "",
        :form_type => "",
        :item_id => "Item",
        :payee_type => "",
        :payee_name_title => "Payee Name Title",
        :payee_name_first => "Payee Name First",
        :payee_name_last => "Payee Name Last",
        :payee_name_suffix => "Payee Name Suffix"
      )
    ])
  end

  it "renders a list of expenditures" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "Item".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "Payee Name Title".to_s, :count => 2
    assert_select "tr>td", :text => "Payee Name First".to_s, :count => 2
    assert_select "tr>td", :text => "Payee Name Last".to_s, :count => 2
    assert_select "tr>td", :text => "Payee Name Suffix".to_s, :count => 2
  end
end
