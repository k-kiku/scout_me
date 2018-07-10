Rails.application.routes.draw do
  devise_for :users#,:controllers => {
    #:registrations => 'users/registrations'
    #} deviseのコントローラを使わない時にコメントアウトを外す
    
  root                                 'static_pages#index'
  get '/users/sign_up',             to: 'users/registrations#new'
  


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
 