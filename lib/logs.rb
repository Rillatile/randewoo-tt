module Logs
  def self.get_logs
    logs = File.readlines("log/#{ENV['RAILS_ENV']}.log")
    logs.delete_if { |line| !line.start_with?('Application log:') }
    logs.map { |line| line.gsub('Application log: ', '') }
  end
end
