require "active_support/core_ext/integer/time"

Rails.application.configure do
  config.cache_classes = false
  config.enable_reloading = true

  config.consider_all_requests_local = true
  config.server_timing = true

  config.cache_store = :memory_store
  config.action_controller.perform_caching = false

  config.active_support.deprecation = :log
  config.active_record.verbose_query_logs = true

  # Enable extra logging to make simulated probes visible to trainees.
  config.log_level = :debug

  # Provide a default secret key for lab mode so Rails can boot without credentials.
  config.secret_key_base = ENV.fetch("SECRET_KEY_BASE", "lab-mode-secret-key-base-change-me")
end
