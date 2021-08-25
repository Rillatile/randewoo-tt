class Setting < ApplicationRecord
  def self.get_value(name)
    Setting.find_by(name: name)&.value
  end

  def self.update(params)
    params.keys.each { |key| Setting.find_or_create_by(name: key).update_attribute(:value, params[key]) }
  end
end
