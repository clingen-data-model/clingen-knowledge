Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :genes, only: [:show, :index] do
    resources :external_resources_genes, only: :index
  end
  resources :conditions, only: [:show, :index] do
    resources :external_resources_conditions, only: :index
  end
  resources :drugs, only: [:show, :index] do
    resources :external_resources_drugs, only: :index
  end
  resources :curations, only: :index
  resources :gene_dosage, only: :index, path: "/gene-dosage"
  resources :gene_disease_assertions, only: [:show, :index], path: "/gene-validity"
  resources :actionability, only: [:show, :index]
  resources :home, only: [:show, :index]

  # Items that need to be secured
  authenticate :agent do
    resources :subscriptions
    resources :notes
    resources :dashboard, only: [:index]  #should only be registered agents
  end


  # TODO refine routes later, for now want routes for 
  # disease, conditions, and phenotypes
  # resources :diseases
  resources :conditions
  # no phenotypes yet, but soon!
  # resources :phenotypes

  devise_for :agents

  root to: 'home#index'
end
