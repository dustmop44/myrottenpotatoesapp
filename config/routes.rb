Rails.application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  resources :movies do
    resources :reviews
  end
  root 'movies#index'
  post '/movies/search_tmdb'
end
