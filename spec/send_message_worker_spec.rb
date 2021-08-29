describe SendMessageWorker do
  it 'enqueues job' do
    message = Message.create

    SendMessageWorker.perform_async(message.id)
    expect(SendMessageWorker).to have_enqueued_sidekiq_job(message.id)
  end

  it 'enqueues job when resend failed messages' do
    message = Message.new
    message.status = Message::STATUS[:not_delivered]
    message.save

    SendMessageWorker.resend_failed_messages
    expect(SendMessageWorker).to have_enqueued_sidekiq_job(message.id)
  end
end
