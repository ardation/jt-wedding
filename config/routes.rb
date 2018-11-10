# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  scope module: 'visitors' do
    resource :invite do
      collection do
        get 'choose'
        get 'find'
        post 'find'
      end
    end
  end
  delete 'sign_out', to: 'visitors#reset'
  root to: 'visitors#index'
end
