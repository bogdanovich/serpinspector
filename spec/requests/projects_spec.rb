require 'spec_helper'

describe "Projects Integration Tests:", js: true do
  describe "Admin should be able to" do
    include_context 'login'
    
    before(:each) do
      @user = FactoryGirl.create(:admin)
      @project = FactoryGirl.create(:project, user: @user)
      login(@user)
    end

    specify "view project list" do
      visit root_path
      click_link 'Projects'
      expect(page).to have_content "#{@user.name.capitalize} projects"
      expect(page).to have_content @project.name
    end

    specify "enqueue project scan" do
      visit root_path
      click_link 'Projects'
      click_link "s_#{@project.id}"
      expect(page).to have_content "report will be created soon."
    end

    specify "delete project" do
      visit root_path
      click_link 'Projects'
      click_link "d_#{@project.id}"
      page.driver.browser.switch_to.alert.accept if page.driver.class == Capybara::Selenium::Driver
      expect(page).to have_content "Project #{@project.name} was deleted."
    end

    specify "create new project" do
      @project_new   = FactoryGirl.build(:project, user: @user)
      @search_engine = FactoryGirl.create(:search_engine)
      visit root_path
      click_link 'Projects'
      click_link "New Project"
      expect(page).to have_button "Create"
      fill_in 'project_name', with: @project_new.name
      click_button 'Create'
      expect(page).to have_content 'Project was successfully created.'
      click_button 'Save'
      expect(page).to have_content '3 errors prohibited this record from being saved'
      fill_in 'keyword_name', with: 'test keyword'
      click_button 'add_keyword_button'
      expect(page).to have_content 'Keyword was successfully added.'
      fill_in 'site_name', with: 'testsite.com'
      click_button 'add_site_button'
      expect(page).to have_content 'Url was successfully added.'
      #page.save_page
      check "project_search_engine_ids_#{@search_engine.id}"
      click_button 'Save'
      expect(page).to have_content 'Project was successfully updated.'
    end

    specify "edit project" do
      @p = FactoryGirl.create(:project_filled, user: @user)
      visit root_path
      click_link 'Projects'
      click_link "e_#{@p.id}"
      expect(page).to have_content "Editing Project"

      # change name
      fill_in 'project_name', with: 'updated_name'
      # change search depth
      fill_in 'project_search_depth', with: '10'
      # uncheck search engine
      uncheck "project_search_engine_ids_#{@p.search_engines.first.id}"
      click_button 'Save'
      expect(page).to have_content "Project was successfully updated."
      expect(page).to have_selector("input#project_name[value='updated_name']")
      expect(page).to have_selector("input#project_search_depth[value='10']")
      find("#project_search_engine_ids_#{@p.search_engines.first.id}").should_not be_checked

      # change scheduler mode to daily
      select 'Daily', from: 'project_scheduler_mode'
      fill_in 'project_scheduler_factor', with: '2'
      select '09', from: 'project_scheduler_time_4i'
      select '30', from: 'project_scheduler_time_5i'
      click_button 'Save'
      expect(page).to have_selector("input#project_scheduler_factor[value='2']")
      expect(page).to have_select('project_scheduler_mode', selected: 'Daily')
      expect(page).to have_select('project_scheduler_time_4i', selected: '09')
      expect(page).to have_select('project_scheduler_time_5i', selected: '30')

      # change scheduler mode to weekly
      select 'Weekly', from: 'project_scheduler_mode'
      fill_in 'project_scheduler_factor', with: '3'
      select '10', from: 'project_scheduler_time_4i'
      select '40', from: 'project_scheduler_time_5i'
      select 'Tuesday', from: 'project_scheduler_day'
      click_button 'Save'
      expect(page).to have_selector("input#project_scheduler_factor[value='3']")
      expect(page).to have_select('project_scheduler_mode', selected: 'Weekly')
      expect(page).to have_select('project_scheduler_time_4i', selected: '10')
      expect(page).to have_select('project_scheduler_time_5i', selected: '40')
      expect(page).to have_select('project_scheduler_day', selected: 'Tuesday')

      # change scheduler mode to monthly
      select 'Monthly', from: 'project_scheduler_mode'
      fill_in 'project_scheduler_factor', with: '4'
      select '11', from: 'project_scheduler_time_4i'
      select '50', from: 'project_scheduler_time_5i'
      select '15th day', from: 'project_scheduler_day'
      click_button 'Save'
      expect(page).to have_selector("input#project_scheduler_factor[value='4']")
      expect(page).to have_select('project_scheduler_mode', selected: 'Monthly')
      expect(page).to have_select('project_scheduler_time_4i', selected: '11')
      expect(page).to have_select('project_scheduler_time_5i', selected: '50')
      expect(page).to have_select('project_scheduler_day', selected: '15th day')

      # add keyword
      fill_in 'keyword_name', with: 'test keyword'
      click_button 'add_keyword_button'
      expect(page).to have_content 'Keyword was successfully added.'
      # delete keyword
      click_link "dk_#{@p.keywords.first.id}"
      expect(page).to have_content 'Keyword was successfully deleted.'

      # add url
      fill_in 'site_name', with: 'testsite.com'
      click_button 'add_site_button'
      expect(page).to have_content 'Url was successfully added.'
      # delete url
      click_link "ds_#{@p.sites.first.id}"
      expect(page).to have_content 'Url was successfully deleted.'
    end
  end
end
