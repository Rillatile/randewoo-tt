require 'rails'
require 'redis'

if Rails.env == "development"
  set :output, { error: "log/cron-error.log", standard: "log/cron.log" }
  set :output, "#{path}/log/cron_log.log"
  set :environment, :development
  env :PATH, ENV['PATH']
end
# Получаем текущее расписание запуска в cron-формате
schedule = Redis.current.get(:schedule)
# Проверка, что расписание задано
if schedule.present?
  every schedule do
    runner 'GenerateMessageWorker.start'
  end
end
