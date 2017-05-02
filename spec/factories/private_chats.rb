FactoryGirl.define do
  factory :private_chat do
    group_ch "private_channel"
    member_ch "user_channel"
  end
end
