Rails.application.routes.draw do
  resources :posts
  devise_for :users, controllers: { omniauth_callbacks:  'users/omniauth_callbacks',
                                    confirmations: 'users/confirmations'}
   
  root                                    'static_pages#index'
  get '/users/sign_up',               to: 'users/registrations#new'
  get '/users/show',                  to: 'users#show'
  get '/users/auth/twitter/callback', to: 'omniauth_callbacks#twitter'
  get '/users/sign_out',              to: 'devise/sessions#destroy'
  get '/users/sign_in',               to: 'devise/sessions#new' 
  post'/users/sign_in',               to: 'devise/sessions#create'
  get '/posts/new',                   to: 'posts#new'
  post'/posts',                       to: 'posts#create'
  get '/confirm/:id',                 to: 'posts#confirm', as: :confirm
  #@TODO 退会する時
  #get '/users/cancel',                to: 'devise/registrations#cancel' 
  
  
 
  
  # For details on the DSL available within this file, see 

 end