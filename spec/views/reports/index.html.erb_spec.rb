require 'spec_helper'

describe "reports/index" do
  before(:each) do
    assign(:reports, [
      stub_model(Report,
        :report_type => "",
        :status => "Status",
        :election_type => "",
        :office_held => "Office Held",
        :office_sought => "Office Sought"
      ),
      stub_model(Report,
        :report_type => "",
        :status => "Status",
        :election_type => "",
        :office_held => "Office Held",
        :office_sought => "Office Sought"
      )
    ])
  end

  it "renders a list of reports" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "Status".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "Office Held".to_s, :count => 2
    assert_select "tr>td", :text => "Office Sought".to_s, :count => 2
  end
end
