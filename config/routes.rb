Rails.application.routes.draw do
  root 'groups#index'

  devise_for :users

  resources :groups do
    member do
      put :join
      delete :leave
      delete :kick_out
    end

    resources :posts
  end

  resources :posts, only: [] do
    resources :comments
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
