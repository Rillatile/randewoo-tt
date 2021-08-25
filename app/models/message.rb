class Message < ApplicationRecord
  after_initialize :generate

  def generate
    # Устанавливаем уникальный идентификатор сообщения
    self.uuid = SecureRandom.uuid
    # Устанавливаем "случайное" значение для сообщения
    self.value = [('a'..'z'), ('A'..'Z'), ('0'..'9')].map(&:to_a).flatten.shuffle.join
  end
end
