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

  def self.start
    # Получаем параметры генерации сообщений
    params = generation_parameters

    (1..params[:quantity]).to_a.each { GenerateMessageWorker.perform_async(params[:min_time], params[:max_time]) }
  end

  private_class_method def self.generation_parameters
    {
      quantity: Redis.current.get('quantity').to_i,
      min_time: Redis.current.get('min_time').to_i,
      max_time: Redis.current.get('max_time').to_i
    }
  end
end
