module Settings
  def self.update(params)
    begin
      params.keys.each { |key| Redis.current.set(key, params[key]) }
    rescue Redis::CannotConnectError
      Rails.logger.error("#{Time.now}, ERROR, \"Connection to Redis could not be established\"")
      return false
    rescue => error
      Rails.logger.error("#{Time.now}, ERROR, \"#{error.message}\"")
      return false
    end
    Rails.logger.info("#{Time.now}, INFO, \"The settings have been updated: #{params}\"")
    true
  end

  def self.current_settings
    begin
      current_settings = {
        schedule: Redis.current.get('schedule'),
        min_time: Redis.current.get('min_time'),
        max_time: Redis.current.get('max_time'),
        quantity: Redis.current.get('quantity'),
        messages_receiver_url: Redis.current.get('messages_receiver_url')
      }
    rescue Redis::CannotConnectError
      Rails.logger.error("#{Time.now}, ERROR, \"Connection to Redis could not be established\"")
      raise Redis::CannotConnectError
    rescue => error
      Rails.logger.error("#{Time.now}, ERROR, \"#{error.message}\"")
      raise error
    end
    current_settings
  end

  def self.empty_settings
    {
      schedule: nil,
      min_time: nil,
      max_time: nil,
      quantity: nil,
      messages_receiver_url: nil
    }
  end

  def self.get_setting_value(name)
    begin
      value = Redis.current.get(name)
    rescue
      value = nil
    end
    value
  end
end
