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
      resources :subscriptions, only: :create
    end
  end

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end
