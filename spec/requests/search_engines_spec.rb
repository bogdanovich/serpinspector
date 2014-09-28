require 'spec_helper'

describe "SearchEngines Integration Test" do
  describe "Admin shold be able to" do
  	include_context 'login'
    
    before(:each) do 
      @user          = FactoryGirl.create(:admin)
      @search_engine = FactoryGirl.create(:search_engine)
      login(@user)
    end

    it "list search engines" do
      visit search_engines_path
      expect(page).to have_content @search_engine.name
    end

    it "view search engine" do
      visit search_engines_path
      click_link "s_#{@search_engine.id}"
      expect(page).to have_content @search_engine.name
    end

    it "edit search engine" do
      se = FactoryGirl.build(:search_engine)
      visit search_engines_path
      click_link "e_#{@search_engine.id}"
      expect(page).to have_content 'Editing Search Engine'
      fill_in 'search_engine_name',                 with: se.name
      fill_in 'search_engine_main_url',             with: se.main_url
      fill_in 'search_engine_query_input_selector', with: se.query_input_selector
      fill_in 'search_engine_item_regex',           with: se.item_regex
      fill_in 'search_engine_next_page_selector',   with: se.next_page_selector
      fill_in 'search_engine_next_page_delay',      with: se.next_page_delay
      fill_in 'search_engine_version',              with: se.version
      click_button 'Update'
      expect(page).to have_content 'SearchEngine was successfully updated.'
      expect(page).to have_content se.name
    end

    it 'sdelete search engine' do
      visit search_engines_path
      click_link "d_#{@search_engine.id}"
      page.driver.browser.switch_to.alert.accept if page.driver.class == Capybara::Selenium::Driver
      expect(page).to have_content "SearchEngine #{@search_engine.name} was deleted."
    end

    it 'create new search engine' do
      se = FactoryGirl.build(:search_engine)
      visit search_engines_path
      click_link "New Search Engine"
      expect(page).to have_content 'New Search Engine'
      fill_in 'search_engine_name',                 with: se.name
      fill_in 'search_engine_main_url',             with: se.main_url
      fill_in 'search_engine_query_input_selector', with: se.query_input_selector
      fill_in 'search_engine_item_regex',           with: se.item_regex
      fill_in 'search_engine_next_page_selector',   with: se.next_page_selector
      fill_in 'search_engine_next_page_delay',      with: se.next_page_delay
      fill_in 'search_engine_version',              with: se.version
      click_button 'Create'
      expect(page).to have_content 'SearchEngine was successfully created.'
      expect(page).to have_content se.name
    end

  end
end
