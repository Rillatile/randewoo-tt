class SendMessageWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(uuid, body)
    params = {
      message_uuid: uuid,
      message_body: body
    }
    encoded_params = URI.encode_www_form(params)

    Rails.logger.info("#{Time.now}, INFO, \"Attempt to send a message '#{uuid}'\"")

    response = Faraday.post(ENV['MESSAGE_RECEIVER_URL'], encoded_params)

    Rails.logger.info("#{Time.now}, INFO, \"Message '#{uuid}' was sent\"")

    if response.status == 200
      Rails.logger.info("#{Time.now}, INFO, \"Message '#{uuid}' was delivered\"")
    else
      Rails.logger.error("#{Time.now}, ERROR, \"Message '#{uuid}' wasn't delivered: #{response.status} - #{response.reason_phrase}\"")
    end
  end
end
