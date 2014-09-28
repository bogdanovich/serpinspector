require 'spec_helper'

describe "Users Integration Test", integration: true do
  describe "Admin should be able to" do
    include_context 'login'
    
    before(:each) do
      @user         = FactoryGirl.create(:admin)
      @another_user = FactoryGirl.create(:user)
      login(@user)
    end

    it "list users" do
      visit users_path
      expect(page).to have_content @another_user.name
    end

    it "view another user" do
      visit users_path
      click_link "s_#{@another_user.id}"
      expect(page).to have_content @another_user.name
    end

    it "another user" do
      visit users_path
      click_link "e_#{@another_user.id}"
      expect(page).to have_content 'Editing User'
      fill_in 'user_name', with: 'updated_user_name'
      select 'Admin', from: 'user_role'
      click_button 'Update'
      expect(page).to have_content "User updated_user_name was successfully updated."
    end

    it "delete another user" do
      visit users_path
      click_link "d_#{@another_user.id}"
      page.driver.browser.switch_to.alert.accept if page.driver.class == Capybara::Selenium::Driver
      expect(page).to have_content "User #{@another_user.name} was deleted."
    end

    it "create new user" do
      new_user = FactoryGirl.build(:admin)
      visit users_path
      click_link "New User"
      fill_in 'user_name', with: new_user.name
      fill_in 'user_password', with: 'test'
      fill_in 'user_password_confirmation', with: 'test'
      select new_user.role.capitalize, from: 'user_role'
      click_button 'Add User'
      expect(page).to have_content "User #{new_user.name} was successfully created."
    end
  end
end
