Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'users/sessions' }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # get "admin" => "admin#home"
  # get "admin/pending" => "admin#pending", as: :pending_approval
  # Keeping above code here in case I come to a better implementation

  scope '/admin' do
    get "/" => "admin#home", as: :admin
    get "dashboard" => "admin#dashboard", as: :admin_dashboard
    get "pending" => "admin#pending", as: :pending_approval
    patch "approve/:id" => "admin#approve", as: :user_approve
    get "transactions" => "admin#transactions", as: :admin_transactions
    get "chart_data" => "admin#chart_data", as: :admin_chart_data
  end
  namespace :admin do
    resources :users
  end

  match 'quote' => "pages#quote", via: [:get, :post]

  scope 'user' do
    get "dashboard" => "pages#dashboard", as: :user_dashboard
    get "chart_data" => "pages#chart_data"
    resources :transactions, only: [ :index, :create ]
    resources :stocks, only: [ :index ]
  end

  get 'memes' => "memes#home"

  # Defines the root path route ("/")
  root "pages#home"
end
