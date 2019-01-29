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
        get 'find/:code', to: 'invites#find', as: 'find_with_code'
      end
    end
  end
  delete 'sign_out', to: 'visitors#reset'
  get 'what_is_marriage', to: 'visitors#what_is_marriage'
  root to: 'visitors#index'
end
