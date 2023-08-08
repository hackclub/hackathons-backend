Rails.application.routes.draw do
  root "hackathons#index"

  get "sign_in", to: "users/authentications#new", as: :sign_in
  scope :my, module: :users do
    resource :authentication, only: [:create, :show]
    resources :sessions, only: [:new, :destroy]
  end

  resources :users, only: [] do
    scope module: :hackathon do
      resources :subscriptions, only: :index do
        get "unsubscribe_all", on: :collection
      end
      namespace :subscriptions do
        resource :bulk, controller: :bulk, only: [:update, :destroy]
      end
    end
  end

  namespace :api, defaults: {format: :json} do
    scope "/v:api_version" do
      resources :hackathons, only: [:index, :show]
      scope module: :hackathon do
        resources :subscriptions, only: :create
      end
    end
  end

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end
