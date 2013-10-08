FactoryGirl.define do
  
  factory :keyword do
    project
    sequence( :name )  { |n| "keyword #{Random.rand(0..1000000000)}" }
    created_at         Time.now
    updated_at         Time.now
  end

end