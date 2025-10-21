require "active_support/core_ext/integer/time"

Rails.application.configure do
  config.cache_classes = true
  config.eager_load = true

  config.consider_all_requests_local = false

  config.public_file_server.enabled = ENV["RAILS_SERVE_STATIC_FILES"].present?
  config.assets.compile = false

  config.log_level = :info
  config.log_tags = [:request_id]

  config.action_controller.perform_caching = true
  config.cache_store = :memory_store

  config.active_storage.service = :local

  config.force_ssl = false

  config.i18n.fallbacks = true
  config.active_support.report_deprecations = false
end
