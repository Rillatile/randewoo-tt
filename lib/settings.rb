module Settings
  def self.update(params)
    params.keys.each { |key| Redis.current.set(key, params[key]) }
    Rails.logger.info("#{Time.now}, INFO, \"The settings have been updated: #{params} \"")
  end

  def self.current_settings
    {
      schedule: Redis.current.get('schedule'),
      min_time: Redis.current.get('min_time'),
      max_time: Redis.current.get('max_time'),
      quantity: Redis.current.get('quantity')
    }
  end
end
