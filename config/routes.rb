Rails.application.routes.draw do
  mount GraphiQL::Rails::Engine, at: '/graphiql', graphql_path: '/graphql' if Rails.env.development?
  post '/graphql', to: 'graphql#execute'

  concern :csv_importable do
    collection do
      get :export_csv
      post :import_csv
    end
  end

  resources :prayers
  resources :events
  resources :landing

  devise_for :masjids, path: 'masjids', controllers: {
    sessions: 'masjids/sessions',
    registrations: 'masjids/registrations'
  }
  resources :masjids do
    resources :payouts, only: %i[new create]
    resources :dashboard, only: %i[index get]
    member do
      get :connect_stripe
      get :open_stripe_dashboard
    end
  end

  resources :fundraisers do
    member do
      patch :toggle_active
    end
  end

  resources :pledges, concerns: :csv_importable
  resources :contacts, concerns: :csv_importable
  resources :donations, concerns: :csv_importable
  resources :revenues, concerns: :csv_importable
  resources :expenses, concerns: :csv_importable

  resources :months do
    collection do
      get :months
    end
  end

  resources :options do
    collection do
      get :pledges
    end
  end

  post '/webhooks/stripe', to: 'webhooks#stripe'

  resources :bulk_deletes, only: [] do
    collection do
      delete :expenses_and_revenues
      delete :pledges
      delete :contacts
      delete :donations
    end
  end

  resources :notifications, only: %i[index] do
    collection do
      patch :mark_as_read
    end
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'landing#index'
end
