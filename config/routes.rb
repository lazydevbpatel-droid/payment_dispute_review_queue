Rails.application.routes.draw do
  devise_for :users
  root to: "home#index"
  
  namespace :webhooks do
    resources :disputes, only: [:create]
  end

  namespace :admin do
    resources :users, except: [:show, :index]
    resources :disputes, only: [:index, :show, :update] do
      resources :evidences, only: [:create]
      member do
        post :reopen
        post :transition
      end
    end

    namespace :reports do
      get :daily_dispute_volume
      get :time_to_decision
    end
  end
end
