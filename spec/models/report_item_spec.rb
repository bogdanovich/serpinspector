require 'spec_helper'

describe ReportItem do
  it { should belong_to :report }
  it { should validate_presence_of :search_engine }
  it { should validate_presence_of :site }
  it { should validate_presence_of :keyword }
  it { should validate_presence_of :position }
end