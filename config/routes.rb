Rails.application.routes.draw do
  mount API::Root => '/'
  mount GrapeSwaggerRails::Engine => '/swagger'

  post 'authenticate', to: 'authentication#authenticate'

  resources :todos do
    resources :items
  end
end
