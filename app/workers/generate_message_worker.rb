require 'sidekiq-scheduler'

class GenerateMessageWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(min_time, max_time)
    # Эмитируем задержку / долгие вычисления
    sleep(rand(min_time..max_time))
    # Генерируем новое сообщение
    message = Message.new

    if message.save
      Rails.logger.info("#{message.created_at}, INFO, \"Message '#{message.uuid}' was created\"")
      SendMessageWorker.perform_async(message.uuid, message.value)
    else
      Rails.logger.error("#{Time.now}, ERROR, \"Message '#{message.uuid}' wasn't saved\"")
    end
  end

  def self.start(messages_quantity, min_time, max_time)
    (1..messages_quantity).to_a.each { GenerateMessageWorker.perform_async(min_time, max_time) }
  end
end
