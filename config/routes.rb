UserGroup::Application.routes.draw do
  match "auth/:provider/callback" => "user/sessions#create"

  namespace :user do
    resource :session, :only => [ :create, :destroy ] do
      collection do
        get :login, :as => :new
      end
    end
  end

  resources :users, :only => [ ] do
    resources :posts, :only => [ :index, :show ]
  end

  resources :posts, :except => [ :show ]

  root :to => 'dummy#index'
end
