require 'sidekiq/web'

base_url = '/v1'

Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, :skip => [:registrations]

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

  get '/dashboard/experiments/create', to: 'dashboard/experiment#create'
  post '/dashboard/experiments/process_create', to: 'dashboard/experiment#process_create'
  get '/dashboard/experiments/:id', to: 'dashboard/experiment#details'
  post '/dashboard/experiments/:id/edit', to: 'dashboard/experiment#edit'
  post '/dashboard/experiments/:id/sample_edit', to: 'dashboard/experiment#sample_edit'
  post '/dashboard/experiments/:id/sample_delete', to: 'dashboard/experiment#sample_delete'

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

end
