module Emilio
  class Railtie < Rails::Railtie
    initializer "emilio.setup_logger" do |app|
      logfile = File.open("#{Rails.root}/log/emilio.log", 'a')
      logfile.sync = true
      Emilio.logger = EmilioLogger.new(logfile)
    end

    initializer "emilio.init_scheduler" do |app|
      app.config.after_initialize do
        if Emilio.scheduler
          if Emilio.scheduler.respond_to?(:init)
            Emilio.scheduler.init
          else
            raise LoadError, "It seems that #{Emilio.scheduler.inspect.split("::").last} was in your Gemfile but declared after Emilio. Please make sure you declare it before Emilio in order to avoid requiring order issues like this."
          end
        end
      end
    end

  end
end
