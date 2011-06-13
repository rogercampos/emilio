module Emilio
  module Schedulers
    module DelayedJob
      def self.init
        # Ideally this should be a recurring Job and this implementation is a
        # poor workaround. Must be refactored if DJ implements real recurring jobs:
        # https://github.com/collectiveidea/delayed_job/wiki/FEATURE:-Adding-Recurring-Job-Support-to-Delayed_Job
        Delayed::Job.enqueue ScheduleJob.new, :run_at => Time.now + Emilio.run_every
      end

      class ScheduleJob
        def perform
          unless Emilio::Schedulers.last_check_at.nil? || ( Time.now > Emilio::Schedulers.last_check_at + Emilio.run_every * 0.9 )
            # Break here to avoid two chains of recurring jobs. Please
            # refactor me! We need your recurring jobs DJ!
            return
          end

          Emilio::Checker.check_emails
          Emilio::Schedulers.last_check_at = Time.now

          Delayed::Job.enqueue ScheduleJob.new, :run_at => Time.now + Emilio.run_every
        end
      end
    end
  end
end


