require 'spec_helper'

describe "FastOverview Integration Test", integration: true do
  describe "Admin should be able to" do
    include_context 'login'

    before(:each) do
      @user = FactoryGirl.create(:admin)
      @report_groups = FactoryGirl.create_list(:report_group_with_reports, 2, user: @user)
      login(@user)
    end

    it "view fast overview" do
      visit root_path
      click_link 'Fast Overview'
      expect(page).to have_content "Overview ("
      expect(page).to have_content @report_groups[0].name
      expect(page).to have_content @report_groups[1].name 
    end
  end
end
