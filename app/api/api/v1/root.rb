module API
  module V1
    class Root < Grape::API
      mount API::V1::Todos
      add_swagger_documentation
    end
  end
end
