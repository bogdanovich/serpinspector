FactoryGirl.define do
  
  factory :report_group do
    user
    sequence(:name)  { |n| "group#{Random.rand(0..1000000000)}" }
    created_at         Time.now
    updated_at         Time.now

    factory :report_group_with_reports do
      ignore do
        reports_count 2
      end

      after(:create) do |report_group, evaluator|
        FactoryGirl.create_list(:report_with_items, evaluator.reports_count, report_group: report_group)
      end
    end
  end

  factory :report do
    report_group
    notification_completed Time.now
    status                 'Finished'
    created_at             Time.now
    updated_at             Time.now

    factory :report_with_items do
      ignore do
        items_count 2
      end

      after(:create) do |report, evaluator|
        FactoryGirl.create_list(:report_item, evaluator.items_count, report: report)
      end
    end
  end

  factory :report_item do
    report
    sequence(:site)           { |n| "site#{Random.rand(0..1000000000)}.com" }
    sequence(:keyword)        { |n| "keyword #{Random.rand(0..1000000000)}" }
    sequence(:search_engine)  { |n| "search engine #{Random.rand(0..1000000000)}" }
    sequence(:position)       { |n| "#{Random.rand(1..100)}" }
    sequence(:position_change){ |n| "#{['','-'][Random.rand(0..1)]}#{Random.rand(1..10)}" }
    created_at                Time.now
    updated_at                Time.now
  end
end
