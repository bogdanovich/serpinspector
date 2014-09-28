require 'spec_helper'

describe "Reports Integration Test", js: true do
  describe "User should be able to" do
    include_context 'login'

    before(:each) do
      @user = FactoryGirl.create(:admin)
      @report_groups = FactoryGirl.create_list(:report_group_with_reports, 2, user: @user)
      login(@user)
    end

    specify "view reports" do
      visit root_path
      click_link 'Reports'
      expect(page).to have_content 'Projects:'
    end

    specify "choose report groups" do
      visit root_path
      click_link 'Reports'
      expect(page).to have_content 'Projects:'
      select @report_groups[1].name, from: 'report_report_group_id'
      find('#selected_report_group').should have_link  @report_groups[1].name
    end

    specify "choose reports" do
      visit root_path
      click_link 'Reports'
      expect(page).to have_content 'Projects:'
      find('#report_id').find("option[value='#{@report_groups[0].reports[0].id}']").select_option
      find('#report').should have_content  @report_groups[0].reports[0].report_items.first.site
    end

    specify "delete reports" do
      visit root_path
      click_link 'Reports'
      expect(page).to have_content 'Projects:'
      report_id = @report_groups[0].reports[0].id
      find('#report_id').find("option[value='#{report_id}']").select_option
      click_button 'report_destroy'
      page.driver.browser.switch_to.alert.accept if page.driver.class == Capybara::Selenium::Driver
      expect(page).to have_content 'Report was deleted!'
    end

    specify "delete report groups" do
      visit root_path
      click_link 'Reports'
      expect(page).to have_content 'Projects:'
      select @report_groups[1].name, from: 'report_report_group_id'
      click_button 'report_group_destroy'
      page.driver.browser.switch_to.alert.accept if page.driver.class == Capybara::Selenium::Driver
      expect(page).to have_content 'Report group was deleted!'
    end
  end
end
