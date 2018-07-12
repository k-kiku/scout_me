Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks:  "users/omniauth_callbacks"}
   
  root                                    'static_pages#index'
  get '/users/sign_up',               to: 'users/registrations#new'
  get '/users/show',                  to: 'users#show'
  get '/users/auth/twitter/callback', to: 'omniauth_callbacks#twitter'
  get '/users/sign_out',              to: 'devise/sessions#destroy'
  get '/users/sign_in',               to: 'devise/sessions#new'
  #@TODO 退会する時
  #get '/users/cancel',                to: 'devise/registrations#cancel'

 
  
  # For details on the DSL available within this file, see 

 end