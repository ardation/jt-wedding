Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  scope module: 'visitors' do
    resource :invite
  end
  root to: 'visitors#index'
end
