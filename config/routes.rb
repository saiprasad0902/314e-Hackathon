Rails.application.routes.draw do
  root to: 'urlparser#index'
  get 'urlparser/index'
  get 'urlparser/show'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
