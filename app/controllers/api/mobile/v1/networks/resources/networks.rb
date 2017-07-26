class API::Mobile::V1::Networks::Resources::Networks < Grape::API
  include API::Mobile::V1::Config
  resource "networks" do
    desc "Follow user by user_id" do
      headers "Authorization" => {
        description: "Token User",
        required:    true
      }
    end
    params do
      requires :user_id, type: String
    end
    post "follow" do
      error!("401 Unauthorized", 401) unless authenticated_user
      follow = me.follows.new
      user   = User.find_by(id: params.user_id)
      error!("Can't find user by id : #{params.user_id}", 401) unless user
      follow.follow_id = params.user_id
      if follow.save
        messages = "Success follow user with id : #{ params.user_id}."

        # notif to user target
        n = Notifier.new({message: "#{user.name} baru saja mengikuti kamu. Ikuti kembali!", data: {
          user:     {
            id:      me.id,
            name:    me.name,
          },
          follower: {
            id:      user.id,
            name:    user.name,
          }
        }, recipient:              [user.player_id], event: "follower_info"})
        os = OneSignal.new({notifier: n})
        os.push
      else
        messages = "Fail follow user with id : #{ params.user_id}."
        error!(follow.errors.full_messages.join(", "), 422)
      end
      {messages: messages}
    end

    desc "Un Follow user by user_id" do
      headers "Authorization" => {
        description: "Token User",
        required:    true
      }
    end
    params do
      requires :user_id, type: String
    end
    delete "unfollow" do
      status 200
      error!("401 Unauthorized", 401) unless authenticated_user
      follow = me.follows.find_by(follow_id: params.user_id)
      if follow
        error!("Can't unfollow user with id : #{ params.user_id}", 401) unless follow.destroy
        messages = "Success unfollow user with id : #{ params.user_id}."
      else
        messages = "No record found"
        error!("Nothing to do.", 422)
      end
      {messages: messages}
    end

    desc "List followers" do
      headers "Authorization" => {
        description: "Token User",
        required:    true
      }
    end
    params do
      requires :user_id, type: String
    end
    get "followers" do
      error!("401 Unauthorized", 401) unless authenticated_user
      user = User.find_by(id: params.user_id)
      error!("Can't find user with id : #{ params.user_id}", 401) unless user
      followers = user.followers
      present :users, followers, with: API::Mobile::V1::Users::Entities::UserInfo
    end

    desc "List followings" do
      headers "Authorization" => {
        description: "Token User",
        required:    true
      }
    end
    params do
      requires :user_id, type: String
    end
    get "followings" do
      error!("401 Unauthorized", 401) unless authenticated_user
      user = User.find_by(id: params.user_id)
      error!("Can't find user with id : #{ params.user_id}", 401) unless user
      followings = user.followings
      present :users, followings, with: API::Mobile::V1::Users::Entities::UserInfo
    end
  end
end
