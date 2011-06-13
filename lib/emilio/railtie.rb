module Emilio
  class Railtie < Rails::Railtie
    initializer "emilio.setup_emilio_logger" do |app|
      logfile = File.open("#{Rails.root}/log/emilio.log", 'a')
      logfile.sync = true
      Emilio.logger = EmilioLogger.new(logfile)
    end
  end
end
