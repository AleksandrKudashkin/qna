require 'sidekiq/web'

Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }

  authenticate :user, ->(u) { u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  concern :votable do
    member do
      patch :vote_up
      patch :vote_down
      delete :cancel_vote
    end
  end

  resources :questions, shallow: true, concerns: :votable do
    resources :comments, only: [:create], defaults: { commentable: 'questions' }
    member do
      patch :subscribe
      delete :unsubscribe
    end
    resources :answers, only: [:create, :destroy, :update], concerns: :votable do
      resources :comments, only: [:create], defaults: { commentable: 'answers' }
      member do
        patch 'best'
      end
    end
  end

  resources :attachments, only: [:destroy]

  root 'questions#index'
  get '/search', to: 'searches#search'
  get '/terms', to: redirect('/terms.html')
  get '/privacy', to: redirect('/privacy.html')

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :profiles, only: [:index] do
        get :me, on: :collection
      end
      resources :questions, shallow: true, only: [:index, :show, :create] do
        resources :answers, only: [:index, :show, :create]
      end
    end
  end
end
