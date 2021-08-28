require 'scheduler'
require 'settings'

class MainController < ApplicationController
  def index
    if request.post?
      if Scheduler.correct_cron?(params[:schedule])
        if Settings.update(params.slice(:schedule, :min_time, :max_time, :quantity, :messages_receiver_url))
          Scheduler.update
        else
          @error = 'Произошла ошибка при взаимодействии с Redis!'
          status = :internal_server_error
        end
      else
        @error = 'Расписание не соответствует формату CRON!'
        status = :bad_request
      end
    end

    begin
      @settings = Settings.current_settings
    rescue Redis::CannotConnectError
      @settings = Settings.empty_settings
      @error = 'Произошла ошибка при взаимодействии с Redis!'
      status = :internal_server_error
    rescue => error
      @settings = Settings.empty_settings
      @error = error.message
      status = :internal_server_error
    end

    @settings = params.slice(:schedule, :min_time, :max_time, :quantity, :messages_receiver_url) if @error.present?
    render status: status || :ok
  end
end
