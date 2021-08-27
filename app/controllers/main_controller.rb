require 'scheduler'
require 'settings'

class MainController < ApplicationController
  def index
    if request.post?
      Settings.update(params.slice(:schedule, :min_time, :max_time, :quantity))
      Scheduler.update
    end

    @settings = Settings.current_settings
  end
end
