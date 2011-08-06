# Copyright (C) 2010, 2011 by Philippe Bourgau

ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller

  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  map.resources :item_category
  map.resources :dishes, :has_many => [:item_category, :items]

  map.resources :cart
  map.destroy_all_cart '/cart', :controller => "cart",
                                :action => "destroy_all",
                                :conditions => { :method => :delete }
  map.add_dish_to_cart '/cart/add_dish/:id', :controller => "cart",
                                             :action => "add_dish",
                                             :conditions => { :method => :post }
  map.forward_cart_to_store '/cart/forward_to_store', :controller => "cart",
                                                      :action => "forward_to_store",
                                                      :conditions => { :method => :post }

  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  #  map.default ':controller/:action/:id'
  #  map.default ':controller/:action/:id.:format'

end
