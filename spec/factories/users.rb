FactoryGirl.define do
  factory :user do
    name "Alam"
    email "alam@pazpo.id"
    phone_number "+6285345678998"
    role 1
    picture "MyString"
    account_kit_id "12345"
  end
  factory :user_2, class: User do
    name "Bima"
    email "bima@pazpo.id"
    phone_number "+6285345631231"
    role 1
    picture "MyString"
    account_kit_id "678910"
  end
end
