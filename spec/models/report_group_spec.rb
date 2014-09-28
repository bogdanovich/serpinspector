require 'spec_helper'

describe ReportGroup do 
  it { should belong_to(:user) }
  it { should have_many(:reports) }
  it { should validate_uniqueness_of(:name).scoped_to(:user_id)}
end