Rails.application.routes.draw do
  post '/edituser', to: "users#update"
  get '/actors', to: "actors#index"
  post '/actors', to: "actors#create"
  post '/signup', to: "users#create"
  post "/login", to: "auth#login"
  get "/auto_login", to: "auth#auto_login"
  delete '/users/:id', to: "users#destroy"
end
