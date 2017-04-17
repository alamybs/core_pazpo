Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  mount API::Mobile::Init, at: "/"
  mount GrapeSwaggerRails::Engine, as: "mobile_doc_v1", at: "documentation/v1"
end
