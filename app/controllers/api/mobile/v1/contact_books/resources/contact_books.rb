class API::Mobile::V1::ContactBooks::Resources::ContactBooks < Grape::API
  include API::Mobile::V1::Config
  resource "contact_books" do
    desc "Request get version app"do
      headers "Authorization" => {
        description: "Token User",
        required:    true
      }
    end
    params do
      requires :contact_book, type: Hash
    end
    post "" do
      error!("401 Unauthorized", 401) unless authenticated_user
      contact_book =  ContactBook.build_contact(user: me, contact_book: params.contact_book)
      {:messages => "Success sync contact."}
    end
  end
end
