Rails.application.routes.draw do
  root "hackathons#index"

  get "sign_in", to: "users/authentications#new", as: :sign_in
  scope :my, module: :users do
    resource :authentication, only: [:create, :show]
    resources :sessions, only: [:new, :destroy]
  end

  namespace :api, defaults: {format: :json} do
    scope "/v:api_version" do
      resources :hackathons, only: [:index, :show]
      scope module: :hackathon do
        resources :subscriptions, only: :create
      end
    end
  end

  namespace :hackathons do
    resources :submissions, only: [:index, :new, :create, :show]
  end

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end
