Rails.application.routes.draw do

  resources :site_events

  resources :historic_search_summaries

  # trying to redirect back to my url after seraches
#  root :to => "searches#new", :constraints => { :domain => "publicsecurities.com" }

 # root :to => "searches#new"
  # You can have the root of your site routed with "root"
  root 'searches#new'
  get 'download-excel-financial-statements' => 'searches#new'

  resources :purchases

  get 'static_pages/limit_access'

  get 'about' => 'static_pages#about'
  get 'later' => 'static_pages#limit_access'

  get 'downlaods/download_page' => 'downloads#download_page'
  get 'downloads/download_statement' # :search_id => search.id

  resources :searches, only: [:new, :create, :show]
  get 'whats_going_on/:num' => 'searches#index'

  get 'most_searched/1980' => 'searches#most_searched'
  #  resources :stocks

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  #for contact form
  get '/contact' => 'contacts#new'
  resources "contacts", only: [:new, :create]

  # This line mounts Monologue's routes at the root of your application.
  # This means, any requests to URLs such as /my-post, will go to Monologue::PostsController.
  # If you would like to change where this engine is mounted, simply change the :at option to something different.
  #
  # We ask that you don't use the :as option here, as Monologue relies on it being the default of "monologue"
  mount Monologue::Engine, at: '/blog' # or whatever path, be it "/blog" or "/monologue"


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
