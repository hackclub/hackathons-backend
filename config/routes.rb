require "sidekiq/web"
require "sidekiq/cron/web"
require "constraints/admin"

Rails.application.routes.draw do
  get "up", to: "rails/health#show", as: :health_check

  root "hackathons#index"

  get "sign_in", to: "users/authentications#new", as: :sign_in
  scope :my, module: :users do
    resource :authentication, only: [:create, :show]
    resources :sessions, only: [:new, :destroy]
  end

  resources :users, only: [] do
    scope module: :hackathons do
      resources :subscriptions, only: :index do
        get "unsubscribe_all", on: :collection
      end
      namespace :subscriptions do
        resource :bulk, controller: :bulk, only: [:update, :destroy]
      end
    end
  end

  namespace :hackathons do
    resources :submissions, only: [:index, :new, :create, :show]
  end

  constraints Constraints::Admin do
    mount Sidekiq::Web => "/sidekiq"
    mount Audits1984::Engine => "/admin/audits"

    namespace :admin do
      resources :hackathons, except: [:new, :create] do
        scope module: :hackathons do
          resource :approval, :rejection, :hold, only: [:create]

          resource :name, :website, :times,
            :expected_attendees, only: :edit
        end
      end
    end
  end

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  namespace :api, defaults: {format: :json} do
    scope "/v:api_version" do
      resources :hackathons, only: [:index, :show]
      namespace :hackathons do
        resources :subscriptions, only: :create
      end

      namespace :stats do
        resources :hackathons, only: :index
        namespace :hackathons do
          resources :subscriptions, only: :index
        end
      end
    end
  end
end
