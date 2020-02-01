Rails.application.routes.draw do
  resources :home
  get 'info', to: 'home#info'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
