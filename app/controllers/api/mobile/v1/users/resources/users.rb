class API::Mobile::V1::Users::Resources::Users < Grape::API
  include API::Mobile::V1::Config
  resource "sessions" do
    desc "Sign Up"
    params do
      requires :name, type: String
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
        user.phone_number   = account_kit["phone"]["numbe"]
        user.email          = params.email
        user.role           = params.role
        user.account_kit_id = account_kit["id"]
        unless user.save
          error!(user.errors.full_messages.join(", "), 422)
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
        user     = User.find_by(account_kit_id: account_kit["id"])
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
    desc "Get user" do
      headers "Authorization" => {
        description: "Token User",
        required:    true
      }
    end
    params do
      requires :id, type: String
    end
    get "/" do
      error!("401 Unauthorized", 401) unless authenticated_user
      user = User.find_by(id: params.id)
      error!("Can't find user by id : #{params.id}", 401) unless user
      present :user, user, with: API::Mobile::V1::Users::Entities::UserInfo
    end
  end
end
