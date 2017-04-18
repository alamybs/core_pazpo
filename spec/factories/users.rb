FactoryGirl.define do
  factory :user do
    name "Alam"
    email "alam@pazpo.id"
    role 1
    picture "MyString"
    authentication_token "thisisatokens"
  end
end
