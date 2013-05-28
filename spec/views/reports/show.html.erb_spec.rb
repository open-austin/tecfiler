require 'spec_helper'

describe "reports/show" do
  before(:each) do
    @report = assign(:report, stub_model(Report,
      :report_type => "",
      :status => "Status",
      :election_type => "",
      :office_held => "Office Held",
      :office_sought => "Office Sought"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
    rendered.should match(/Status/)
    rendered.should match(//)
    rendered.should match(/Office Held/)
    rendered.should match(/Office Sought/)
  end
end
