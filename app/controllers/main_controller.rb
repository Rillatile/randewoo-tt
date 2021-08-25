class MainController < ApplicationController
  def index
    if request.post?
      Setting.update(params.slice(:schedule, :min_time, :max_time, :quantity))
    end

    @settings = {
      schedule: Setting.get_value(:schedule),
      min_time: Setting.get_value(:min_time),
      max_time: Setting.get_value(:max_time),
      quantity: Setting.get_value(:quantity) || 0
    }
  end
end
