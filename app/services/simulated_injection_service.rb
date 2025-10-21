class SimulatedInjectionService
  class << self
    attr_accessor :override_enabled

    # Analyses incoming payloads and simulates a blind SQL injection response pattern without
    # ever executing dynamic SQL. All database access elsewhere in the app stays on ActiveRecord.
    def check(raw_payload, request: nil, metadata: {})
      return :disabled unless enabled?

      payload = raw_payload.to_s
      entry = build_log_entry(payload, request, metadata)

      if filtered?(payload)
        entry[:result] = :filtered
        write_log(entry)
        return :filtered
      end

      if payload.include?(config[:delay_marker].to_s)
        entry[:result] = :time_delay
        write_log(entry)
        return :time_delay
      end

      entry[:result] = :pass
      write_log(entry)
      :pass
    end

    def delay_seconds
      config[:delay_seconds].to_i
    end

    def log_entries
      logger.read(log_store_key) || []
    end

    def clear_log!
      logger.delete(log_store_key)
    end

    def enabled?
      return override_enabled unless override_enabled.nil?

      Rails.application.config.x.lab_mode_enabled
    end

    def enable!
      self.override_enabled = true
    end

    def disable!
      self.override_enabled = false
    end

    def reset_override!
      self.override_enabled = nil
    end

    def filtered_patterns
      Array(config[:filtered_patterns])
    end

    def delay_marker
      config[:delay_marker].to_s
    end

    private

    def config
      Rails.application.config.x.lab_simulation || {}
    end

    def filtered?(payload)
      filtered_patterns.any? { |pattern| payload.include?(pattern.to_s) }
    end

    def build_log_entry(payload, request, metadata)
      {
        at: Time.current,
        payload: payload,
        ip: request&.respond_to?(:remote_ip) ? request.remote_ip : nil,
        metadata: metadata
      }
    end

    def write_log(entry)
      history = log_entries
      history << entry
      history = history.last(log_limit)
      logger.write(log_store_key, history)
    end

    def log_limit
      (config[:log_limit] || 50).to_i
    end

    def logger
      Rails.application.config.x.simulation_logger
    end

    def log_store_key
      "probe_history"
    end
  end
end
