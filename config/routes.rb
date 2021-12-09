Rails.application.routes.draw do
  devise_for :users, :token_authentication_key => 'authentication_key'
  # root "articles#index"

  resources :articles do
    resources :comments
  end

  mount Base => '/'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
