Rails.application.routes.draw do
  resources :scores

  #goals have scores...
  resources :goals do
    resources :scores
    post 'import_okrs', on: :collection
    get 'show_export', on: :collection
    get 'timeline', on: :collection
    get 'search', on: :collection, as: :search
    #TODO route for sdp goals
    #get 'single-departmental-plan', on: :collection, as: :sdp
    get 'sdp', on: :collection, as: :sdp
  end

  resources :teams
  resources :groups
  resources :users

  resources :actuals do
    post 'import', on: :collection
  end

  #google_oauth2...or others someday
  get '/auth/:provider/callback' => 'sessions#create'
  get '/auth/failure' => 'sessions#handle_failure'

  get '/mockup' => 'welcome#mockup'

  #convenience redirect
  get '/signin' => 'sessions#new', as: :signin
  get '/signout' => 'sessions#destroy', as: :signout

  get '/about' => 'welcome#about', as: :about
  get '/dashboard' => 'welcome#dashboard', as: :dashboard

  resources :roles do
    post 'import', on: :collection
    #get 'vacant', on: :collection
  end
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  #root 'welcome#index'
  root 'goals#index'
  #root 'roles#import'

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
