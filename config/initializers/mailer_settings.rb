#
# Load ActionMailer settings from config/email.yml.
#
TecfilerAr::Application.configure do
  a = YAML::load(File.open("#{Rails.root.to_s}/config/email.yml"))
  b = a[Rails.env]
  if b
    b.each do |k, v|
      case k
      when :default_options
	# Workaround for :default_options, which is documented in
	# http://guides.rubyonrails.org/action_mailer_basics.html
	# but it doesn't really work that way.
	ActionMailer::Base.default(v)
      else
        config.action_mailer[k] = v
      end
    end
  end
end

