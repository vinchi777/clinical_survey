Ccq::Application.routes.draw do

  match "home/index" => "home#index", :as => "home", :via => [:get, :post]
  devise_for :users, :controllers => { :registrations => "registrations" }

  authenticated :user do
    root :to => "home#index"
  end
  unauthenticated :user do
    devise_scope :user do
      get "/" => "devise/sessions#new"
    end
  end

  resources :surveys
  resources :user_surveys
  resources :results do
    collection do
      get 'email'
      get 'send_email'
      get 'retrieve'
      get 'token'
    end
  end
end
