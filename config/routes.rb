Rails.application.routes.draw do
  devise_for :users, controllers: { :omniauth_callbacks => "omniauth_callbacks" }
    
  root                                    'static_pages#index'
  get '/users/sign_up',               to: 'users/registrations#new'
  get 'users/show',                   to: 'users#show'
  get '/users/auth/twitter/callback', to: 'omniauth_callbacks#twitter'
  


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
 