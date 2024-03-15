# frozen_string_literal: true

Rails.application.routes.draw do
  resources :users, only: :update, format: :json

  get 'up' => 'rails/health#show', as: :rails_health_check
end
