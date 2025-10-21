simulation_config = Rails.application.config_for(:lab_simulation).deep_symbolize_keys

Rails.application.config.x.lab_simulation = simulation_config
Rails.application.config.x.lab_mode_enabled = ENV["LAB_MODE"] == "1" || Rails.env.lab?

# Store probe logs in memory by default. Educators can swap this for Redis or a DB table
# by assigning a custom object responding to #write and #read (see SimulatedInjectionService).
Rails.application.config.x.simulation_logger = ActiveSupport::Cache::MemoryStore.new(
  size: 64.megabytes,
  namespace: "simulated_injection"
)
