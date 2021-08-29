class SendMessageWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(message_id)
    message = Message.find(message_id)
    encoded_params = URI.encode_www_form(message.as_json)

    Rails.logger.info("Attempt to send a message '#{message.uuid}' - Application log")

    begin
      response = Faraday.post(Redis.current.get('messages_receiver_url'), encoded_params)
    rescue => error
      Rails.logger.error("Message '#{message.uuid}' wasn't sent: #{error.message} - Application log")
      message.update_attribute(:status, Message::STATUS[:sending_failed])
      return
    end

    Rails.logger.info("Message '#{message.uuid}' was sent  - Application log")
    message.update_attribute(:status, Message::STATUS[:sent])

    if response.status == 200
      Rails.logger.info("#Message '#{message.uuid}' was delivered - Application log")
      message.update_attribute(:status, Message::STATUS[:delivered])
    else
      Rails.logger.error("Message '#{message.uuid}' wasn't delivered: #{response.status} - #{response.reason_phrase} - Application log")
      message.update_attribute(:status, Message::STATUS[:not_delivered])
    end
  end

  def self.resend_failed_messages
    ids = Message.where(status: [Message::STATUS[:sending_failed], Message::STATUS[:not_delivered]]).pluck(:id)

    ids.each { |id| SendMessageWorker.perform_async(id) }
  end
end
