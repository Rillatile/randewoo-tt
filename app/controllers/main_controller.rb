class MainController < ApplicationController
  def index
    Setting.update(params.slice(:schedule, :min_time, :max_time, :quantity)) if request.post?

    @settings = {
      schedule: Setting.get_value(:schedule),
      min_time: Setting.get_value(:min_time),
      max_time: Setting.get_value(:max_time),
      quantity: Setting.get_value(:quantity) || 0
    }

    GenerateMessageWorker.start(1, 1, 3)
  end
end
