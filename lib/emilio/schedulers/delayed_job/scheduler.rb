module Emilio
  module Schedulers
    module DelayedJob
      def self.init
        puts "DJ Scheduler initialized for the first time!!!!"
      end

      class ScheduleJob
        def perform
          Emilio::Checker.check_emails
        end
      end
    end
  end
end


