Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :genes, only: [:show, :index]
  resources :conditions, only: [:show, :index]
  resources :curations, only: :index
  resources :gene_dosage, only: :index, path: "/gene-dosage"
  resources :gene_validity, only: [:show, :index], path: "/gene-validity"
  resources :actionability, only: [:show, :index]
  resources :home, only: [:index]

  devise_for :agents

  root to: 'home#index'
end
