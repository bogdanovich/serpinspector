require 'spec_helper'

describe 'Rank Checker Job Tests:' do
  specify 'fetch positions from google.com and bing.com search engines' do
    p = FactoryGirl.create(:project_rank_checking)
    r = RankCheckerJob.new(p.id)
    result = r.perform
    expect(result).to eq 'done'
  end

  specify 'fetch positions from yahoo search engine' do
    p = FactoryGirl.create(:project_rank_checking_yahoo)
    r = RankCheckerJob.new(p.id)
    result = r.perform
    expect(result).to eq 'done'
  end
end