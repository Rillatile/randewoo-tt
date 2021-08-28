module Scheduler
  def self.correct_cron?(cron)
    cron_regex = /(?i-mx:^(@(reboot|yearly|annually|monthly|weekly|daily|midnight|hourly)|((\*?[\d\/,\-]*)\s){3}(\*?([\d\/,\-]|(jan|feb|mar|apr|may|jun|jul|aug|sep|oct|nov|dec))*\s)(\*?([\d\/,\-]|(sun|mon|tue|wed|thu|fri|sat))*))$)/

    !!cron.match(cron_regex)
  end

  def self.update
    system('whenever --update-crontab')
    Rails.logger.info("#{Time.now}, INFO, \"The schedule has been updated with a new value '#{Settings.get_setting_value('schedule')}'\"")
  end
end
