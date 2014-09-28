require 'spec_helper'

describe Project do
  it { should validate_presence_of :name }
  it { should belong_to(:user) }
  it { should validate_numericality_of(:search_depth).with_message('can only be natural number') }
  it { should validate_inclusion_of(:search_depth).in_range(10..200).with_message('can only be between 10 and 200') }
  it { should validate_inclusion_of(:scheduler_mode).in_array(['On Demand', 'Daily', 'Weekly', 'Monthly']) }
  it { should validate_inclusion_of(:scheduler_factor).in_range(1..999).with_message("can only be between 1 and 999") }
  it { should validate_inclusion_of(:scheduler_day).in_range(1..31).with_message("can only be between 1 and 31") }
  it { should have_many :sites }
  it { should have_many :keywords }
  it { should have_and_belong_to_many(:search_engines) }
end