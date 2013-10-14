FactoryGirl.define do
  
  factory :project do
    user
    
    sequence( :name )  { |n| "project#{Random.rand(0..1000000000)}" }
    search_depth       100
    scheduler_mode     'On Demand'
    scheduler_factor   1
    scheduler_time     '2000-01-01 06:00:00'
    scheduler_day      1
    created_at         Time.now
    updated_at         Time.now
  
    factory :project_filled do
      ignore do
        keywords_count 2
        sites_count    1
      end

      search_engines { [create(:search_engine), create(:search_engine)] }

      after(:create) do |project, evaluator|
        FactoryGirl.create_list(:keyword, evaluator.keywords_count, project: project)
        FactoryGirl.create_list(:site,    evaluator.sites_count,    project: project)
      end
    end

    factory :project_rank_checking_bing do

      search_engines { [create(:bing_com)] }

      after(:create) do |project, evaluator|
        FactoryGirl.create(:keyword, project: project, name: 'search engine')
        FactoryGirl.create(:keyword, project: project, name: 'google')
        FactoryGirl.create(:site, project: project, name: 'google.com')
      end
    end

    factory :project_rank_checking_google do

      search_engines { [create(:search_engine)] }

      after(:create) do |project, evaluator|
        FactoryGirl.create(:keyword, project: project, name: 'search engine')
        FactoryGirl.create(:keyword, project: project, name: 'google')
        FactoryGirl.create(:site, project: project, name: 'google.com')
      end
    end

    factory :project_rank_checking_yahoo do

      search_engines { [create(:yahoo_com)] }

      after(:create) do |project, evaluator|
        FactoryGirl.create(:keyword, project: project, name: 'search engine')
        FactoryGirl.create(:keyword, project: project, name: 'google')
        FactoryGirl.create(:site, project: project, name: 'google.com')
      end
    end
  end
end
