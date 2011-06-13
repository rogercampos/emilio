Emilio::Schedulers.registered_schedulers << :delayed_job

module Emilio
  module Schedulers
    module DelayedJob
      def self.setup
        unless defined?(Delayed)
          raise LoadError, "Please include 'delayed_job' in your Gemfile or require it manually before using this scheduler."
        end

        Emilio::Schedulers::DelayedJob
      end
    end
  end
end

require 'emilio/schedulers/delayed_job/scheduler' if defined?(Delayed)
