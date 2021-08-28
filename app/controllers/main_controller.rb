require 'scheduler'
require 'settings'

class MainController < ApplicationController
  def index
    if request.post?
      if Scheduler.correct_cron?(params[:schedule])
        Settings.update(params.slice(:schedule, :min_time, :max_time, :quantity, :messages_receiver_url))
        Scheduler.update
      else
        @error = 'Расписание не соответствует формату CRON!'
      end
    end

    @settings = Settings.current_settings
    @settings[:schedule] = params[:schedule] if @error.present?
  end
end
