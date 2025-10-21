require "active_support/core_ext/integer/time"

Rails.application.configure do
  config.enable_reloading = true

  config.consider_all_requests_local = true
  config.server_timing = true

  config.cache_store = :memory_store
  config.action_controller.perform_caching = false

  config.active_storage.service = :local

  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.perform_caching = false

  config.active_support.deprecation = :log
  config.active_record.migration_error = :page_load

  config.active_record.verbose_query_logs = true
  config.active_record.query_log_tags_enabled = true

  config.assets.quiet = true
end
