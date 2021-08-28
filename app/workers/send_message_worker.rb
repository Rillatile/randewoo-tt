class SendMessageWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(message_id)
    message = Message.find(message_id)
    encoded_params = URI.encode_www_form(message.as_json)

    Rails.logger.info("#{Time.now}, INFO, \"Attempt to send a message '#{message.uuid}'\"")

    response = Faraday.post('http://127.0.0.1:8000', encoded_params)

    Rails.logger.info("#{Time.now}, INFO, \"Message '#{message.uuid}' was sent\"")
    message.update_attribute(:status, Message::STATUS[:sent])

    if response.status == 200
      Rails.logger.info("#{Time.now}, INFO, \"Message '#{message.uuid}' was delivered\"")
      message.update_attribute(:status, Message::STATUS[:delivered])
    else
      Rails.logger.error("#{Time.now}, ERROR, \"Message '#{message.uuid}' wasn't delivered: #{response.status} - #{response.reason_phrase}\"")
      message.update_attribute(:status, Message::STATUS[:sending_failed])
    end
  end
end
