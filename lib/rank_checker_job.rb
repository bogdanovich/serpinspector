# -*- encoding : utf-8 -*-
require "selenium-webdriver"
require 'fileutils'

module Enumerable
    def random_line
      selected = nil
      each_with_index { |line, lineno| selected = line if rand < 1.0/lineno }
      return selected.chomp if selected
    end
end

class RankCheckerJob < Struct.new(:project_id)

  def perform
    @project = Project.find_by(id: project_id)
    if @project
      puts @project.name + " Inspecting SERPs..."
      log "#{Time.now} #{@project.name} Inspecting SERPs..."
      @search_engines = @project.search_engines.where(active: true)
      @keywords = @project.keywords
      @sites_urls = @project.sites
      if @search_engines.blank? or @keywords.blank? or @sites_urls.blank?
        log "#{Time.now} Nothing to inspect (search_engines, keywords, urls should be defined)"
        return
      end

      @not_found_symbol = Settings.not_found_symbol

      @report_group = ReportGroup.find_or_create_by(name: @project.name, user_id: @project.user_id)
      if @report_group.display_order.nil?
        @report_group.display_order = @project.id
        @report_group.save
      end
      @report = @report_group.reports.new
      @report.status = "Scanning"
      @report.save!
      @fetch_rankings_error = ''
      begin
        @search_engines.each do |search_engine|
          @keywords.each do |keyword|
            begin
              positions = fetch_rankings(search_engine, keyword, @sites_urls, @project.search_depth)
            rescue Exception => details
              log details.to_s
              positions = {}
              @fetch_rankings_error = details.to_s
              @report.update_attribute :status, @fetch_rankings_error
            end
            @sites_urls.each do |site_url|
              position_change = get_position_change(positions[site_url.name], site_url.name, keyword.name, search_engine.name)
              @report_item = @report.report_items.new({:search_engine => search_engine.name,
                                                      :keyword => keyword.name,
                                                      :site => site_url.name,
                                                      :position => positions[site_url.name],
                                                      :position_change => position_change})
              @report_item.save!
              @project.last_scanned_at = Time.now
              @project.save!
              update_best_position(positions[site_url.name], site_url.name, keyword.name, search_engine.name)
            end
          end
        end
        @report.update_attribute :status, (@fetch_rankings_error.blank? ? "Finished" : @fetch_rankings_error)
      rescue => details
        log details.to_s.lines.first
        @report.update_attribute :status, details.to_s
      end
    else
      return "unknown project (maybe deleted?)"
    end
    return "done"
  end

  
  def fetch_rankings(search_engine, keyword, sites_urls, search_depth)
    @user_agent = random_user_agent
    
    capabilities = Selenium::WebDriver::Remote::Capabilities.phantomjs('phantomjs.page.settings.userAgent' => @user_agent, 'phantomjs.page.customHeaders.Accept-Language' => 'en')
    @browser = Selenium::WebDriver.for :phantomjs, desired_capabilities: capabilities

    #profile = Selenium::WebDriver::Firefox::Profile.new
    #profile.native_events = false
    #profile['general.useragent.override'] = @user_agent
    #capabilities = Selenium::WebDriver::Remote::Capabilities.firefox(:firefox_profile => profile)
    #@browser = Selenium::WebDriver.for :firefox, desired_capabilities: capabilities

     # init result
    log        "#{Time.now} Selected User Agent: #{@user_agent}"
    log        "#{Time.now} Search engine: " + search_engine.name + ". Keyword: " + keyword.name
    positions = {}
    sites_urls.each {|site_url| positions[site_url.name] = @not_found_symbol }

    query_input = {}
    query_input[:tag], query_input[:value] = search_engine.query_input_selector.split(':')

    next_page = {}
    next_page[:tag], next_page[:value] = search_engine.next_page_selector.split(':')
    item_regex      = Regexp.new(search_engine.item_regex, Regexp::IGNORECASE | Regexp::MULTILINE)
    
    current_depth = 0
    
    begin

      @browser.navigate.to search_engine.main_url
      log "#{Time.now} Navigating to: #{search_engine.main_url}"
      sleep(random_delay(search_engine.next_page_delay))
      log "#{Time.now} Fetching search results: #{current_depth.to_s} #{@browser.current_url}"

      File.open("result.html", 'w') { |file| file.write(@browser.page_source) }

      element = @browser.find_element(query_input[:tag], query_input[:value])
      @browser.action.move_to(element).click(element).perform
      element.send_keys keyword.name
      element.submit

      while positions.has_value?(@not_found_symbol) and current_depth < search_depth do
        sleep(random_delay(search_engine.next_page_delay))

        # user emulation: moving mouse to input query field
        element = @browser.find_element(query_input[:tag], query_input[:value])
        @browser.action.move_to(element).perform

        #user emulation: moving mouse downwards randomly
        rand(1..10).times do |i|
          @browser.action.move_by(0, rand(30..200)).perform
        end  
        
        page_body = @browser.page_source
        fetched_urls = page_body.scan(item_regex)

        #log "#{Time.now} Found #{fetched_urls.length} urls"

        if fetched_urls.empty?
          log "#{Time.now} Search results not found. IP was banned OR Need to update regular expressions"
          log "#{Time.now} Search results not found. Saving page..."
          #File.open("result.html", 'w') { |file| file.write(page_body) }
          save_page_body(search_engine.name + ' ' + keyword.name, page_body)
          @browser.quit
          return positions
        end

        sites_urls.each do |site_url|
          fetched_urls.each_with_index do |fetched_url, index|
            if unescaped_url(fetched_url.first).include?(site_url.name)
              positions[site_url.name] = current_depth + index + 1
              break
            end
          end if positions[site_url.name] == @not_found_symbol
        end
        current_depth += fetched_urls.length
        log "#{Time.now} Fetching search results: #{current_depth.to_s} #{@browser.current_url}"

        # user emulation: click random link with 20% chance
        if rand(1..10) <= 3
          current_url = @browser.current_url
          link_elements = @browser.find_elements(:tag_name, 'a')
          # don't click on first 5 links
          link_elements = link_elements[5..-1]
          random_link = link_elements[rand(link_elements.length)]
          log "#{Time.now} User emulation: clicking random link #{random_link.attribute('href')}"
          @browser.action.move_to(random_link).click(random_link).perform
          sleep(random_delay(search_engine.next_page_delay))
          log "#{Time.now} User emulation: navigating back #{current_url}"
          @browser.navigate.to current_url
          sleep(random_delay(search_engine.next_page_delay))
        end
   
        element = @browser.find_element(next_page[:tag], next_page[:value])
        @browser.action.move_to(element).click(element).perform
      end
    rescue => details
      log "#{Time.now} Selenium exception: #{details.to_s.lines.first}"
      save_page_body("Exception #{search_engine.name} #{keyword.name}", @browser.page_source)
      @browser.quit
      return positions
    end
    log "#{Time.now} Found #{search_engine.name} keyword '#{keyword.name}': #{positions}"
    @browser.quit
    positions
  end

  def get_position_change(current_position, site_name, keyword_name, search_engine_name)
    position_change = 0
    @previous_position = ScanRegistry.last_position(site_name, keyword_name, search_engine_name)
    if current_position.to_i > 0 and @previous_position.value.to_i > 0
      position_change = @previous_position.value.to_i - current_position.to_i
    end
    @previous_position.value = current_position
    @previous_position.save
    position_change
  end

  def save_page_body(file_name, file_body)
    dir = ::Rails.root.to_s + '/log/error_pages'
    FileUtils.mkpath dir unless File.directory? dir
    File.open(dir + '/' + file_name + ".html", 'w') do |f|
      f.write file_body.respond_to?(:force_encoding) ? file_body.force_encoding("UTF-8") : file_body
    end
  end

  def update_best_position(current_position, site_name, keyword_name, search_engine_name)
    @best_position = ScanRegistry.best_position(site_name, keyword_name, search_engine_name)
    best_position = @best_position.value.to_i
    cur_position  = current_position.to_i
    if (best_position == 0 and cur_position > 0) or (cur_position < best_position and cur_position > 0)
      @best_position.value = current_position
      @best_position.save
    end
  end

  def unescaped_url(url)
    unescaped_url = CGI::unescapeHTML(url)
    unescaped_url = CGI::unescape(unescaped_url) if unescaped_url[0,7] == 'http%3a'
    unescaped_url
  end

  def random_user_agent
    f = open(Settings.crawler_user_agents_file)
    useragent = f.random_line
    f.rewind
    f.close
    useragent
  end

  def log(message)
    logger  = Delayed::Worker.logger if logger.nil?
    puts message
    logger.info message
  end

  def random_delay(base_delay)
    base_delay + ((rand(2) > 0)? 1 : -1) * rand(0) * base_delay / 2
  end
end


