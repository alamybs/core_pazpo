class API::Mobile::V1::Users::Resources::Users < Grape::API
  include API::Mobile::V1::Config
  resource "sessions" do
    desc "Sign Up"
    params do
      optional :picture, :type => Rack::Multipart::UploadedFile
      requires :name, type: String
      requires :player_id, type: String
      requires :email, allow_blank: false, regexp: /.+@.+/
      requires :authorization_code, type: String
      requires :role, type: Integer, default: 1, values: [1, 2], desc: '{1: Property Agent, 2: Independent Agen}'
    end
    post "sign_up" do
      account_kit                    = AccountKit.new
      account_kit.authorization_code = params.authorization_code
      user                           = User.new
      if account_kit.access_user
        user.name           = params.name
        user.phone_number   = account_kit.user["phone"]["number"]
        user.email          = params.email
        user.role           = params.role
        user.player_id      = params.player_id
        user.picture        = params.picture if params.picture.present?
        user.account_kit_id = account_kit.user["id"]
        unless user.save
          error!(user.errors.full_messages.join(", "), 422)
        end
        # notif friend in contact
        cb = ContactBook.find_by(phone_number: user.phone_number)
        if cb.present?
          player_ids = []
          cb.contact_relations.where(status: :owner).each do |cr|
            player_ids << cr.user.player_id unless user.player_id.eql?(cr.user.player_id)
          end
          n  = Notifier.new({message: "Teman anda #{user.name} baru saja bergabung di PAZPO", data: {
            user: {
              id:      user.id,
              name:    user.name,
              picture: user.picture
            }
          }, recipient:               player_ids, event: "friend_join"})
          os = OneSignal.new({notifier: n})
          os.push
        end
        messages = "Success Create user."
      else
        messages = account_kit.errors
      end
      present :messages, messages, type: :json
      present :user, user, with: API::Mobile::V1::Users::Entities::User
    end

    desc "Sign in"
    params do
      requires :authorization_code, type: String
    end
    post "/sign_in" do
      account_kit                    = AccountKit.new
      account_kit.authorization_code = params.authorization_code
      if account_kit.access_user
        user     = User.find_by(account_kit_id: account_kit.user["id"])
        messages = "Success Create user."
      else
        messages = account_kit.errors
        error!(account_kit.errors, 401) unless user
      end
      present :messages, messages, type: :json
      present :user, user, with: API::Mobile::V1::Users::Entities::User
    end
  end
  resource "users" do
    desc "get user" do
      headers "Authorization" => {
        description: "Token User",
        required:    true
      }
    end
    params do
      optional :q, type: String
    end
    get "/" do
      error!("401 Unauthorized", 401) unless authenticated_user
      users = User.all
      users = users.where("LOWER(name) LIKE ?", "%#{params.q.downcase}%").order("name ASC") if params.q.present?
      present :users, users, with: API::Mobile::V1::Users::Entities::UserInfo
    end

    desc "Get current user" do
      headers "Authorization" => {
        description: "Token User",
        required:    true
      }
    end
    get "/current" do
      error!("401 Unauthorized", 401) unless authenticated_user
      present :user, @me, with: API::Mobile::V1::Users::Entities::User
    end
    desc "Detail user" do
      headers "Authorization" => {
        description: "Token User",
        required:    true
      }
    end
    params do
      requires :id, type: String
    end
    get "/show" do
      error!("401 Unauthorized", 401) unless authenticated_user
      user = User.find_by(id: params.id)
      error!("Can't find user by id : #{params.id}", 401) unless user
      present :user, user, with: API::Mobile::V1::Users::Entities::UserInfo
    end

    desc "Update users"
    params do
      optional :picture, type: File
      requires :name, type: String
      requires :email, allow_blank: false, regexp: /.+@.+/
    end
    put "" do
      error!("401 Unauthorized", 401) unless authenticated_user
      me.name    = params.name
      me.email   = params.email
      me.picture = params.picture if params.picture.present?
      unless me.save
        error!(me.errors.full_messages.join(", "), 422)
      end
      present :user, me, with: API::Mobile::V1::Users::Entities::User
    end

    desc "Update player id"
    params do
      requires :player_id, type: String
    end
    put "player_id" do
      error!("401 Unauthorized", 401) unless authenticated_user
      me.player_id = params.player_id
      unless me.save
        error!(me.errors.full_messages.join(", "), 422)
      end
      present :user, me, with: API::Mobile::V1::Users::Entities::User
    end
  end
end
