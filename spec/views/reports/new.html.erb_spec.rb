require 'spec_helper'

describe "reports/new" do
  before(:each) do
    assign(:report, stub_model(Report,
      :report_type => "",
      :status => "MyString",
      :election_type => "",
      :office_held => "MyString",
      :office_sought => "MyString"
    ).as_new_record)
  end

  it "renders new report form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", reports_path, "post" do
      assert_select "input#report_report_type[name=?]", "report[report_type]"
      assert_select "input#report_status[name=?]", "report[status]"
      assert_select "input#report_election_type[name=?]", "report[election_type]"
      assert_select "input#report_office_held[name=?]", "report[office_held]"
      assert_select "input#report_office_sought[name=?]", "report[office_sought]"
    end
  end
end
