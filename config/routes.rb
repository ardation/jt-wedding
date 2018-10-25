Rails.application.routes.draw do
  resource :invite
  root to: 'application#index'
end
