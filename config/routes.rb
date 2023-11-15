require "sidekiq/web"
require "sidekiq/cron/web"

Rails.application.routes.draw do
  root "hackathons#index"

  get "sign_in", to: "users/authentications#new", as: :sign_in
  scope :my, module: :users do
    resource :authentication, only: :create
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
    mount Sidekiq::Web => "/admin/sidekiq" if Rails.env.production?
    mount Audits1984::Engine => "/admin/audits"

    namespace :admin do
      resources :hackathons, except: [:new, :create] do
        scope module: :hackathons do
          resource :approval, :rejection, :hold, only: [:create]

          resource :name, :website, :times,
            :expected_attendees, only: :edit

          collection do
            resources :subscriptions, only: :destroy
          end
        end
      end

      resources :users, only: [:index, :show, :update] do
        scope module: :users do
          resource :name, :email_address, only: :edit
          resource :promotion, only: [:create, :destroy]
        end
      end
    end
  end

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

  get "up", to: "rails/health#show", as: :health_check
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end
