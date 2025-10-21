require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module TodoLabSim
  class Application < Rails::Application
    config.load_defaults 7.1

    # Add a dedicated lab environment so educators can enable simulated attacks without risk.
    if config.respond_to?(:assets)
      config.assets.precompile += %w[application.css]
    end

    config.generators do |g|
      g.helper false
      g.assets false
    end
  end
end
