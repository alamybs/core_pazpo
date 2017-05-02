class API::Mobile::V1::PrivateChats::Entities::PrivateChat < Grape::Entity
  expose :group_ch, as: :group_channel
  expose :member_ch, as: :member_channel
end