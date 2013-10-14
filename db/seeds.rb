#encoding: UTF-8


User.delete_all
User.create({:name => 'test', :password => 'test', :role => 'admin'})
User.create({:name => 'test_user', :password => 'test'})

Project.delete_all
Keyword.delete_all
Site.delete_all
SearchEngine.delete_all


1.times { |proj_index|
  project = Project.create!(:name => "google.com")
  Keyword.create(:project_id => project.id, :name => "google")
  Keyword.create(:project_id => project.id, :name => "search engine")
  Site.create(:project_id => project.id, :name => "google.com")
}

SearchEngine.create(:name => 'Google.com (En)',
                    :main_url => 'http://www.google.com',
                    :query_input_selector => 'name:q',
                    :item_regex => '<li class="g"><h3 class="r"><a href="\/url\?q=(.*?)&amp;sa=',
                    :next_page_selector => 'id:pnnext')

SearchEngine.create(:name => 'Bing.com (En)',
                    :main_url => 'http://www.bing.com',
                    :query_input_selector => 'name:q',
                    :item_regex => '(?:<div class="sb_tlst"><h3>|<li class="b_algo"><h2>)<a href="([^"]+)"',
                    :next_page_selector => 'class:sb_pagN')

SearchEngine.create(:name => 'Yahoo.com (En)',
                    :main_url => 'http://yahoo.com',
                    :query_input_selector => 'name:p',
                    :item_regex => 'id="link\-\d" .+? href="([^"]+)"',
                    :next_page_selector => 'id:pg-next')




