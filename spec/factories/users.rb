FactoryGirl.define do
  factory :user do
    name "Alam"
    email "alam@pazpo.id"
    phone_number "+6285345678998"
    role 1
    account_kit_id "12345"
    picture File.open(File.join(Rails.root, '/spec/fixtures/avatar.jpg'))
  end
  factory :user_2, class: User do
    name "Bima"
    email "bima@pazpo.id"
    phone_number "+6285345631231"
    role 1
    account_kit_id "678910"
    picture File.open(File.join(Rails.root, '/spec/fixtures/avatar.jpg'))
  end
end
