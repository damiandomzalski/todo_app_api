module API
  module V1
    class Todos < Grape::API
      version 'v1'
      format :json

      before do
        error!("401 Unauthorized", 401) unless authenticated
      end
      helpers do
        def authenticated
          current_user
        end

        def current_user
          @current_user ||= AuthorizeApiRequest.call(request.headers).result
        end
      end

      resource :todos do
        desc "Return list of todo lists"
        get do
          Todo.all
        end

        desc "Return single todo list"
        params do
          requires :id, type: Integer, desc: 'Todo id'
        end
        route_param :id do
          get do
            Todo.find(params[:id])
          end
        end

        desc "Create todo list"
        params do
          requires :title, type: String, desc: 'Title of list'
        end
        post do
          Todo.create!(title: params[:title], created_by: current_user.email)
        end

        desc "Update todo list"
        params do
          requires :id, type: String, desc: 'Todo ID.'
          requires :title, type: String, desc: 'Title of list.'
        end
        put ':id' do
          Todo.find(params[:id]).update(title: params[:title], created_by: current_user.email)
        end

        desc "Assigned items"
        params do
          requires :id, type: Integer, desc: 'Todo id'
        end
        route_param :id do
          desc "Get assigned items for todo"
          get 'items' do
            Todo.find(params[:id]).items
          end

          desc "Create assigned items for todo"
          params do
            requires :name, type: String, desc: 'Item\'s name.'
            requires :done, type: Boolean, desc: 'Done or not.'
          end
          post 'items' do
            Todo.find(params[:id]).items.create!(name: params[:name], done: params[:done])
          end

          desc "Items actions"
          params do
            requires :item_id, type: Integer, desc: 'Item id'
          end
          route_param 'items/:item_id' do
            desc "Update assigned items for todo"
            params do
              requires :name, type: String, desc: 'Item\'s name.'
              requires :done, type: Boolean, desc: 'Done or not.'
            end
            put do
              Todo.find(params[:id]).items.find(params[:item_id]).update(name: params[:name], done: params[:done])
            end

            desc "Get assigned item"
            get do
              Todo.find(params[:id]).items.find(params[:item_id])
            end
          end
        end
      end
    end
  end
end
