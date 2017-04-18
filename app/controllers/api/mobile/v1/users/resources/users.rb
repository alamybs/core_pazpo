class API::Mobile::V1::Users::Resources::Users < Grape::API
  include API::Mobile::V1::Config
  resource "sessions" do
    desc "Sign Up"
    params do
      requires :name, type: String
      requires :email, allow_blank: false, regexp: /.+@.+/
      requires :phone_number, type: String
      requires :authentication_token, type: String
      requires :role, type: Integer, default: 1, values: [1, 2], desc: '{1: Property Agent, 2: Independent Agen}'
    end
    post "/" do
      user                      = User.new
      user.name                 = params.name
      user.phone_number         = params.phone_number
      user.email                = params.email
      user.role                 = params.role
      user.authentication_token = params.authentication_token
      unless user.save
        error!(user.errors.full_messages.join(", "), 422)
      end
      present user, with: API::Mobile::V1::Users::Entities::User
    end
  end
end
