require 'spec_helper'

describe Report do
  it { should belong_to(:report_group) }
  it { should have_many :report_items }
end