module Scheduler
  def self.update
    system('whenever --update-crontab')
    Rails.logger.info("#{Time.now}, INFO, \"The schedule has been updated with a new value '#{Redis.current.get('schedule')}'\"")
  end
end
