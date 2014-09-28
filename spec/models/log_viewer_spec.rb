require 'spec_helper'

describe LogViewer do
  it { should validate_presence_of :file_name }
  it { should validate_presence_of :height }
  it { should validate_inclusion_of(:height).in_range(1..10000).with_message('can only be between 1 and 10000') }
end