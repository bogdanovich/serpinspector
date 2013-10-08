# checks all the projects and schedules CheckRankingJob for each project if needed
# this job scheduled directly in worker.rb (vendor\plugins\delayed_job\lib\delayed\worker.rb)

class SchedulerJob
  def self.perform
    begin
      puts "#{Time.now} SchedulerJob.perform!"
      logger  = Delayed::Worker.logger if logger.nil?
      logger.info "#{Time.now} SchedulerJob.perform!"
      @projects = Project.all(:conditions => ["scheduler_mode <> 'On Demand'"])
      @projects.each do |project|
        next if project.scheduler_factor < 1
        if self.ready_for_schedule(project.scheduler_mode, project.scheduler_time, project.scheduler_factor, project.scheduler_day, project.last_scheduled_at)
          self.schedule_rank_checker(project)
        end
      end
    end
    true
  end

  def self.schedule_rank_checker(project)
    if Delayed::Job.enqueue(RankCheckerJob.new(project.id))
      project.last_scheduled_at = Time.zone.now
      project.save!
    end
  end

  def self.ready_for_schedule(s_mode, s_time, s_factor, s_day, s_last_scheduled, time_now = nil)
    ct = (time_now.nil?) ? Time.zone.now : time_now
    case s_mode
    when 'Daily'
      return false unless (ct.hour == s_time.hour and ct.min >= s_time.min) or ct.hour > s_time.hour
      return true if s_last_scheduled.nil?
      #next line returns true when last_scheduled time more than 21 hour ago
      #return true ct - s_last_scheduled >= s_factor.days - 3.hours
      return true if Date.civil(ct.year, ct.month, ct.day) - s_factor + 1  > Date.civil(s_last_scheduled.year, s_last_scheduled.month, s_last_scheduled.day)
    when 'Weekly'
      return false unless ct.wday == s_day and ((ct.hour == s_time.hour and ct.min >= s_time.min) or ct.hour > s_time.hour)
      return true if s_last_scheduled.nil?
      #next line returns true when last_scheduled time more than factor * weeks-3 hours ago
      #return true if ct - s_last_scheduled >= s_factor.weeks - 3.hours
      return true if Date.civil(ct.year, ct.month, ct.day) - 7 * s_factor + 1  > Date.civil(s_last_scheduled.year, s_last_scheduled.month, s_last_scheduled.day)
    when 'Monthly'
      return false unless ct.mday == s_day and ((ct.hour == s_time.hour and ct.min >= s_time.min) or ct.hour > s_time.hour)
      return true if s_last_scheduled.nil?
      #return true if ct - s_last_scheduled >= (ct - ct.months_ago(s_factor)) - 3.hours
      time_x = ct.months_ago(s_factor)
      return true if Date.civil(time_x.year, time_x.month, time_x.day) + 1  > Date.civil(s_last_scheduled.year, s_last_scheduled.month, s_last_scheduled.day)
    end
    false
  end

end