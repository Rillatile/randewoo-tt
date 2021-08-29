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
# Повторная отправка неотправившихся либо недоставленных сообщений
every 1.hour do
  runner 'SendMessageWorker.resend_failed_messages'
end
