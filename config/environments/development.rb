Ccq::Application.configure do
  config.cache_classes = false
  config.whiny_nils = true
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false
  config.action_mailer.raise_delivery_errors = true
  config.active_support.deprecation = :log
  config.action_dispatch.best_standards_support = :builtin
  config.active_record.mass_assignment_sanitizer = :strict
  config.active_record.auto_explain_threshold_in_seconds = 0.5
  config.assets.compress = false
  config.assets.debug = true

  data = YAML::load(File.open("config/ccq.yml")) if File.exist? "config/ccq.yml"
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    :address => data["mailer"]["address"],
    :port    => data["mailer"]["port"],
    :domain  => data["mailer"]["domain"],
    :authentication => data["mailer"]["authentication"],
    :user_name => data["mailer"]["user_name"],
    :password  => data["mailer"]["password"],
    :enable_starttls_auto => data["mailer"]["enable_starttls_auto"]
  }
end
