# Copyright (C) 2010, 2011, 2012 by Philippe Bourgau

MesCourses::Application.routes.draw do
  get "cgu/index"

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'

  root to: 'welcome#index'

  mount Blogit::Engine => "/blog"

  devise_for :users, controllers: { sessions: "sessions" }

  resources :item_categories

  resources :dishes do
    resources :item_categories
    resources :items
  end
  match '/dishes' => 'dishes#index', as: :user_root, via: :get

  resources :cart_lines
  match '/cart_lines' => 'cart_lines#destroy_all', as: :destroy_all_cart_lines, via: :delete
  match '/cart_lines/add_dish/:id' => 'cart_lines#add_dish', as: :add_dish_to_cart_lines, via: :post

  resources :orders

  match '/features' => "features#index"
  match '/cgu' => "cgu#index"
end
