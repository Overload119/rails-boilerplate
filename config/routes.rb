# typed: false
# frozen_string_literal: true

require 'sidekiq/web'
require 'sidekiq/cron/web'

Rails.application.routes.draw do
  # Sidekiq Web UI (protect in production!)
  mount Sidekiq::Web => '/sidekiq'

  # Inertia TODO routes
  resources :todos, only: %i[index create update destroy] do
    member { patch :toggle }
    collection { delete :clear_completed }
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  get 'up' => 'rails/health#show', :as => :rails_health_check

  # Root path - serves the Inertia TODO app
  root 'todos#index'
end
