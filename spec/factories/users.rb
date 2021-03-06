FactoryGirl.define do
  factory :user do
    name "Alam"
    email "alam@pazpo.id"
    phone_number "+6285345678998"
    role 1
    account_kit_id "12345"
    player_id "123450987531"
    picture File.open(File.join(Rails.root, '/spec/fixtures/avatar.jpg'))
  end
  factory :user_2, class: User do
    name "Bima"
    email "bima@pazpo.id"
    phone_number "+6285345631231"
    role 1
    account_kit_id "678910"
    player_id "12345092345678"
    picture File.open(File.join(Rails.root, '/spec/fixtures/avatar.jpg'))
  end
  factory :user_3, class: User do
    name "Jonggrang"
    email "jonggrang@pazpo.id"
    phone_number "+6278945631231"
    role 1
    account_kit_id "4233221"
    player_id "187650987531"
    picture File.open(File.join(Rails.root, '/spec/fixtures/avatar.jpg'))
  end
  factory :user_4, class: User do
    name "Rara"
    email "rara@pazpo.id"
    phone_number "+6285345631231"
    role 1
    account_kit_id "4235821"
    player_id "1234503456731"
    picture File.open(File.join(Rails.root, '/spec/fixtures/avatar.jpg'))
  end
  factory :user_5, class: User do
    name "Dore"
    email "dore@pazpo.id"
    phone_number "+62887656231"
    role 1
    account_kit_id "9873618"
    player_id "98765435678908"
    picture File.open(File.join(Rails.root, '/spec/fixtures/avatar.jpg'))
  end
end
