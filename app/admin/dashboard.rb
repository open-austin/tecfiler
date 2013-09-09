ActiveAdmin.register_page "Dashboard" do

  menu :priority => 1, :label => proc{ I18n.t("active_admin.dashboard") }

  content :title => proc{ I18n.t("active_admin.dashboard") } do

    # div :class => "blank_slate_container", :id => "dashboard_default_message" do
      # span :class => "blank_slate" do
        # span I18n.t("active_admin.dashboard_welcome.welcome")
        # small I18n.t("active_admin.dashboard_welcome.call_to_action")
      # end
    # end

    # Here is an example of a simple dashboard with columns and panels.
    
    columns do
      column do
        panel "Reports" do
          para "Number of reports in progress: #{Report.in_progress.count}"
          para "Number of reports in submitted status: #{Report.submitted.count}"
          para "Number of reports in filed successfully: #{Report.filed.count}"
          para "Number of reports in error status: #{Report.error.count}"
        end
      end
      column do
        panel "General" do
          para "Number of registered users: #{User.count}"
          para "Number of filers: #{Filer.count}"
          para "Number of treasurers: #{Treasurer.count}"
        end
      end

    end
    
    columns do
      column do
        panel "Reports needing to be reviewed" do
          ul do
            Report.submitted.map do |report|
              li link_to("#{report.filer.name} - #{report.period_end}", admin_report_path(report))
            end
          end
        end
      end

      column do
        panel "Rejected reports" do
          ul do
            Report.error.map do |report|
              li link_to("#{report.filer.name} - #{report.period_end}", admin_report_path(report))
            end
          end
        end
      end
    end
  end # content

end
