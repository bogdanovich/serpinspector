FactoryGirl.define do
  
  factory :user do
    sequence( :name )  { |n| "user#{Random.rand(0..1000000000)}" }
    salt               'foobar'
    #password           'test'
    hashed_password    { User.encrypted_password('test', salt)  }  
    role               'user'
    created_at         Time.now
    updated_at         Time.now
  end

  factory :admin, class: User do
    sequence( :name )  { |n| "user#{Random.rand(0..1000000000)}" }
    salt               'foobar'
    #password           'test'
    hashed_password    { User.encrypted_password('test', salt)  }  
    role               'admin'
    created_at         Time.now
    updated_at         Time.now
  end

end

