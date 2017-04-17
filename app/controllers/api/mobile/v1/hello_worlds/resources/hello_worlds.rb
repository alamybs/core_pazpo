class API::Mobile::V1::HelloWorlds::Resources::HelloWorlds < Grape::API
  include API::Mobile::V1::Config
  resource "hello_worlds" do
    desc "Version"
    get "version" do
      results = {version: "v1"}
      present results
    end
    desc "Get All"
    get "/" do
      results = [{id: 1 , title: "Hello World"},{id: 2 , title: "Hello World 2"},{id: 3 , title: "Hello World 3"},]
      present results, with: API::Mobile::V1::HelloWorlds::Entities::Hello
    end
    desc "Get by id"
    params do
      requires :id, type: Integer
    end
    get "/:id" do
      results = [{id: 1 , title: "Hello World"},{id: 2 , title: "Hello World 2"},{id: 3 , title: "Hello World 3"},]
      present results[params.id-1], with: API::Mobile::V1::HelloWorlds::Entities::Hello
    end
    desc "Create"
    params do
      requires :title, type: String
    end
    post "/" do
      results = [{id: 4 , title: params.title }]
      present results, with: API::Mobile::V1::HelloWorlds::Entities::Hello
    end
    desc "Update"
    params do
      requires :id, type: Integer
      requires :title, type: String
    end
    put "/:id" do
      error!("Can't find id #{params.id}", 422) unless [1,2,3].include?(params.id)
      results = [{id: params.id , title: params.title }]
      present results, with: API::Mobile::V1::HelloWorlds::Entities::Hello
    end
    desc "Delete"
    params do
      requires :id, type: Integer
    end
    delete "/:id" do
      error!("Can't find id #{params.id}", 422) unless [1,2,3].include?(params.id)

      present "success deleted data with id #{params.id}"
    end


  end
end
