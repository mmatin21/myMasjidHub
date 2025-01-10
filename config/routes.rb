Rails.application.routes.draw do
  if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql"
  end
  post "/graphql", to: "graphql#execute"

  resources :pledges
  resources :prayers
  resources :fundraisers
  resources :events
  resources :landing

  devise_for :masjids, path: 'masjids', controllers: {
    sessions: "masjids/sessions",
    registrations: "masjids/registrations"
  }
  resources :masjids do
    resources :payouts, only: [:new, :create]
    resources :dashboard, only: [:index]
    member do
      get :connect_stripe
      get :open_stripe_dashboard
    end
  end

  resources :contacts do
    collection do
      get :export_csv
    end
  end

  resources :donations do
    collection do
      get :export_csv
      post :import_csv
    end
  end

  resources :revenues do
    collection do
      get :export_csv
      post :import_csv
    end
  end
  resources :expenses do
    collection do
      get :export_csv
      post :import_csv
    end
  end

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
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "landing#index"

end
