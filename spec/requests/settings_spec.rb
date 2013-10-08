require 'spec_helper'

describe "Settings Integration Tests:" do
  describe "Admin" do
    include_context 'login'

    before(:each) do
      @user = FactoryGirl.create(:admin)
      login(@user)
    end

    it "should be able to view settings" do
      visit '/settings'
      expect(page).to have_content 'Admin Email'
    end

    it "should be able to update settings" do
      visit '/settings'
      fill_in 'settings_form_admin_email', with: 'updated@serpinspector.com'
      fill_in 'settings_form_not_found_symbol', with: '--'
      click_button 'Update'
      expect(page).to have_content 'Settings was successfully updated.'
      expect(page).to have_selector("input#settings_form_admin_email[value='updated@serpinspector.com']")
      expect(page).to have_selector("input#settings_form_not_found_symbol[value='--']")
    end
  end
end
