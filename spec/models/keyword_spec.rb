require 'spec_helper'

describe Keyword do
  it { should validate_presence_of :name }
  it { should belong_to(:project) }
end