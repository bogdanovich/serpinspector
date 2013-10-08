Delayed::Worker.destroy_failed_jobs = false
Delayed::Worker.sleep_delay = 60 * 5
Delayed::Worker.max_attempts = 3
Delayed::Worker.max_run_time = 40.minutes

# Add SchedulerJob.perform in front of every work (to generate new jobs by scheduler)
class Delayed::Worker
  alias :old_work_off :work_off
  def work_off(num = 100)
    SchedulerJob.perform
    old_work_off(num)
  end
end

Delayed::Worker.logger =
  ActiveSupport::Logger.new("log/delayed_job.log", Rails.logger.level)
if caller.last =~ /.*\/script\/delayed_job:\d+$/
  ActiveRecord::Base.logger = Delayed::Worker.logger
end