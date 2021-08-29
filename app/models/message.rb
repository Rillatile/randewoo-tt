class Message < ApplicationRecord
  after_initialize :generate

  STATUS = {
    send: 'send',
    sent: 'sent',
    delivered: 'delivered',
    sending_failed: 'sending_failed',
    not_delivered: 'not_delivered'
  }

  def generate
    if self.uuid.blank?
      # Устанавливаем уникальный идентификатор сообщения
      self.uuid = SecureRandom.uuid
      # Устанавливаем "случайное" значение для сообщения
      self.value = [('a'..'z'), ('A'..'Z'), ('0'..'9')].map(&:to_a).flatten.shuffle.join
      # Устанавливаем статус сообщения
      self.status = STATUS[:send]
    end
  end
end
