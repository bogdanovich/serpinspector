FactoryGirl.define do
  
  factory :site do
    project
    sequence( :name )  { |n| "site#{Random.rand(0..1000000000)}.com" }
    created_at         Time.now
    updated_at         Time.now
  end

end
