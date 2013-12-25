MuseServer::Application.routes.draw do

  resources :song_graphs

  get '/signup' => 'users#new'
  #get '/login' => 'sessions#new'
  post '/signin' => 'sessions#create'
  delete '/signout' => 'sessions#destroy'
  get '/getCSRFToken' => 'sessions#getCSRFToken'
  get '/fav' => 'tags#fav'

  resources :users, only:[:create, :show, :update] do 
    post "update_password"
    collection do
      post "forgot_password"
    end
  end

  resources :users_marks

  resources :albums, only:[:index, :show]

  resources :musics, only:[:index, :show] do
    member do
      get "like"
      get "dislike"
      get "unmark"
    end
    collection do
      get "search"
    end
  end

  resources :tags, only:[:index, :show]

  resources :tag_relationships, only:[:index, :show]

  resources :artists, only:[:index, :show]

  root 'static_page#home'
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
