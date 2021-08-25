require 'sidekiq-scheduler'

class GenerateMessageWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(min_time, max_time)
    # Эмитируем задержку / долгие вычисления
    sleep(min_time..max_time)
    # Генерируем новое сообщение
    Message.create
  end
end
