require 'spec_helper'

describe SearchEngine do
  it { should have_and_belong_to_many(:projects) }
  it { should validate_presence_of(:main_url)}
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:query_input_selector) }
  it { should validate_presence_of(:item_regex) }
  it { should validate_presence_of(:next_page_selector) }


end