require 'spec_helper'

describe User do
  it { should have_many(:projects) }
  it { should have_many(:report_groups) }
  it { should validate_presence_of(:name) }
  it { should validate_confirmation_of(:password)}
  it { should validate_inclusion_of(:role).in_array(User::ROLES)}
end