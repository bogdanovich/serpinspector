require 'spec_helper'

describe "LogViewer Integration Test", js: true, integration: true do
  describe "Admin" do
    include_context 'login'

    before(:each) do
      @user = FactoryGirl.create(:admin)
      login(@user)
    end

    context "should be able to" do
      it "view log" do
        visit '/log_viewer'
        expect(page).to have_content 'Show last'
      end

      it "update log" do
        visit '/log_viewer'
        fill_in 'log_viewer_height', with: '50'
        click_button 'Update'
        expect(page).to have_content 'Log settings were successfully updated.'
      end

      it "clear log" do
        visit '/log_viewer'
        click_link 'Clear'
        page.driver.browser.switch_to.alert.accept if page.driver.class == Capybara::Selenium::Driver
        expect(page).to have_content 'was cleaned.'
      end

      it "select file" do
        visit '/log_viewer'
        click_link 'delayed_job.log'
        expect(page).to have_content 'delayed_job.log was selected.'
      end  
    end

    

  end
end
