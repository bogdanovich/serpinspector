require 'spec_helper'

require 'scheduler_job'

describe 'Scheduler tests' do
  it "should be true 00" do
    r = SchedulerJob.ready_for_schedule('Daily', Time.parse('00:30'), 1, 1, Time.parse("2010-01-30 23:35:10"), Time.parse("2010-01-31 00:31:23"))
    expect(r).to be true
  end

  it "should be false 001" do
    r = SchedulerJob.ready_for_schedule('Daily', Time.parse('00:30'), 1, 1, Time.parse("2010-01-31 00:00:10"), Time.parse("2010-01-31 00:31:23"))
    expect(r).to be false
  end

  it "should be true 01" do
    r = SchedulerJob.ready_for_schedule('Daily', Time.parse('15:30'), 1, 1, Time.parse("2010-01-30 15:35:10"), Time.parse("2010-01-31 15:31:23"))
    expect(r).to be true
  end

  it "should be false 02" do
    r = SchedulerJob.ready_for_schedule('Daily', Time.parse('15:32'), 1, 1, Time.parse("2010-01-30 15:35:10"), Time.parse("2010-01-31 15:31:23"))
    expect(r).to be false
  end

  it "should be false 03" do
    r = SchedulerJob.ready_for_schedule('Daily', Time.parse('15:32'), 2, 1, Time.parse("2010-01-30 15:35:10"), Time.parse("2010-01-31 15:31:23"))
    expect(r).to be false
  end

  it "should be true 04" do
    r = SchedulerJob.ready_for_schedule('Daily', Time.parse('15:30'), 2, 1, Time.parse("2010-01-29 15:35:10"), Time.parse("2010-01-31 15:31:23"))
    expect(r).to be true
  end

  it "should be false 05" do
    r = SchedulerJob.ready_for_schedule('Weekly', Time.parse('00:30'), 1, 3, Time.parse("2010-01-30 15:35:10"), Time.parse("2010-01-31 15:31:23"))
    expect(r).to be false
  end

  it "should be false 06" do
    r = SchedulerJob.ready_for_schedule('Weekly', Time.parse('00:30'), 1, 3, Time.parse("2010-01-20 15:35:10"), Time.parse("2010-01-28 15:31:23"))
    expect(r).to be false
  end

  it "should be true 07" do
    r = SchedulerJob.ready_for_schedule('Weekly', Time.parse('00:30'), 1, 3, Time.parse("2010-01-20 15:35:10"), Time.parse("2010-01-27 15:31:23"))
    expect(r).to be true
  end

  it "should be false 08" do
    r = SchedulerJob.ready_for_schedule('Weekly', Time.parse('15:40'), 1, 3, Time.parse("2010-01-20 15:35:10"), Time.parse("2010-01-27 15:31:23"))
    expect(r).to be false
  end

  it "should be false 09" do
    r = SchedulerJob.ready_for_schedule('Weekly', Time.parse('15:30'), 2, 3, Time.parse("2010-01-20 15:35:10"), Time.parse("2010-01-27 15:31:23"))
    expect(r).to be false
  end

  it "should be true 10" do
    r = SchedulerJob.ready_for_schedule('Weekly', Time.parse('15:30'), 2, 3, Time.parse("2010-01-13 15:35:10"), Time.parse("2010-01-27 15:31:23"))
    expect(r).to be true
  end

  it "should be true 11" do
    r = SchedulerJob.ready_for_schedule('Monthly', Time.parse('15:30'), 1, 15, Time.parse("2010-01-15 15:35:10"), Time.parse("2010-02-15 15:31:23"))
    expect(r).to be true
  end

  it "should be false 12" do
    r = SchedulerJob.ready_for_schedule('Monthly', Time.parse('15:30'), 1, 15, Time.parse("2010-01-15 15:35:10"), Time.parse("2010-02-16 15:31:23"))
    expect(r).to be false
  end

  it "should be false 13" do
    r = SchedulerJob.ready_for_schedule('Monthly', Time.parse('15:30'), 1, 15, Time.parse("2010-01-15 15:35:10"), Time.parse("2010-02-14 15:31:23"))
    expect(r).to be false
  end

  it "should be false 14" do
    r = SchedulerJob.ready_for_schedule('Monthly', Time.parse('15:30'), 2, 15, Time.parse("2010-01-15 15:35:10"), Time.parse("2010-02-15 15:31:23"))
    expect(r).to be false
  end

  it "should be true 15" do
    r = SchedulerJob.ready_for_schedule('Monthly', Time.parse('15:30'), 2, 15, Time.parse("2010-01-15 15:35:10"), Time.parse("2010-03-15 15:31:23"))
    expect(r).to be true
  end

  it "should be true 16" do
    r = SchedulerJob.ready_for_schedule('Monthly', Time.parse('13:20'), 2, 15, Time.parse("2009-12-15 15:35:10"), Time.parse("2010-02-15 15:30:23"))
    expect(r).to be true
  end

  it "should be true 17" do
    r = SchedulerJob.ready_for_schedule('Monthly', Time.parse('15:31'), 2, 15, Time.parse("2010-01-15 15:35:10"), Time.parse("2010-03-15 15:31:23"))
    expect(r).to be true
  end

  it "should be false 18" do
    r = SchedulerJob.ready_for_schedule('Monthly', Time.parse('15:32'), 2, 15, Time.parse("2010-01-15 15:35:10"), Time.parse("2010-03-15 15:31:23"))
    expect(r).to be false
  end
end

