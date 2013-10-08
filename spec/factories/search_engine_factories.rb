FactoryGirl.define do

  factory :search_engine do
    sequence(:name)            { |n| "Google.com #{Random.rand(0..1000000000)}" }
    main_url                   'http://google.com'
    query_input_selector       'name:q'
    item_regex                 '<h3 class="r"><a\s?(?:onmousedown=".*?")? href="([^"]+)"'
    next_page_selector         'id:pnnext'
    next_page_delay            7
    version                    '0'
    active                     true
    created_at                 Time.now
    updated_at                 Time.now
  end

  factory :bing_com, class: SearchEngine do
    sequence(:name)            { |n| "Bing.com #{Random.rand(0..1000000000)}" }
    main_url                   'http://www.bing.com'
    query_input_selector       'name:q'
    item_regex                 '<div class="sb_tlst"><h3><a href="([^"]+)"'
    next_page_selector         'class:sb_pagN'
    next_page_delay            7
    version                    0
    active                     true
    created_at                 Time.now
    updated_at                 Time.now
  end

  factory :yahoo_com, class: SearchEngine do
    sequence(:name)            { |n| "Yahoo.com #{Random.rand(0..1000000000)}" }
    main_url                   'http://yahoo.com'
    query_input_selector       'name:p'
    item_regex                 'id="link\-\d" .+? href="([^"]+)"'
    next_page_selector         'id:pg-next'
    next_page_delay            7
    version                    0
    active                     true
    created_at                 Time.now
    updated_at                 Time.now
  end

end
