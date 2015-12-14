require 'sidekiq/web'

base_url = '/v1'

Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users

  # Static routes
  get '/docs', to: redirect('/docs/index.html')

  # Rails controller#action routes
  root 'dashboard/home#index'

  # Exclude users from administrative duties at routes level
  authenticate :user, lambda { |user| user.is_admin? } do
    mount Sidekiq::Web => "/sidekiq"
    get '/dashboard/admin', to: 'dashboard/services_admin#index'
  end

  # Manage participants
  get '/dashboard/participants/index', to: 'dashboard/participant#index'
  get '/dashboard/participants/index/:page', to: 'dashboard/participant#index'
  
  get '/dashboard/participants/:id', to: 'dashboard/participant#details'
  post '/dashboard/participants/:id/reset_pw', to: 'dashboard/participant#reset_pw'

  # Manage samples
  get '/dashboard/samples/index', to: 'dashboard/sample#index'
  get '/dashboard/samples/index/:page', to: 'dashboard/sample#index'

  get '/dashboard/samples/create', to: 'dashboard/sample#create'
  post '/dashboard/samples/process_create', to: 'dashboard/sample#process_create'
  get '/dashboard/samples/:id', to: 'dashboard/sample#details'
  post '/dashboard/samples/:id/edit', to: 'dashboard/sample#edit'

  # Manage experiments
  get '/dashboard/experiments/index', to: 'dashboard/experiment#index'
  get '/dashboard/experiments/index/:page', to: 'dashboard/experiment#index'

  # Data export
  get '/dashboard/data/index', to: 'dashboard/data#index'
  post '/dashboard/data/csv', to: 'dashboard/data#csv'

  #### API ROUTES ####

  post base_url + '/participant/register', to: 'api/participant#register'

  post base_url + '/experiment/create', to: 'api/experiment#create'
  post base_url + '/experiment/:id', to: 'api/experiment#modify'
  get base_url + '/experiment/:id', to: 'api/experiment#retrieve'
  delete base_url + '/experiment/:id', to: 'api/experiment#delete'


  get base_url + '/sample', to: 'api/sample#retrieve'
  post base_url + '/sample/create', to: 'api/sample#create'
  post base_url + '/sample/set', to: 'api/sample#set_retrieve'
  get base_url + '/sample/:id', to: 'api/sample#retrieve_by_id'
  delete base_url + '/sample/:id', to: 'api/sample#delete'
  post base_url + '/sample/:id', to: 'api/sample#modify'
  get base_url + '/sample/search', to: 'api/sample#search'

  post base_url + '/score/record', to: 'api/score#create'

  #get 'dashboard/experiments', to 'dashboard#experiments'
  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
