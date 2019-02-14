Rails.application.routes.draw do
  devise_for :moviegoers, :controllers => { :omniauth_callbacks => "moviegoers/omniauth_callbacks"}
  resources :movies
  root 'movies#index'
end
