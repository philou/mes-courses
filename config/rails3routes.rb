MesCourses::Application.routes.draw do
  match '/' => 'welcome#index'
  match 'users' => '#index', :as => :devise_for
  resources :item_categories
  resources :dishes
  resources :cart_lines
  match '/cart_lines' => 'cart_lines#destroy_all', :as => :destroy_all_cart_lines, :via => :delete
  match '/cart_lines/add_dish/:id' => 'cart_lines#add_dish', :as => :add_dish_to_cart_lines, :via => :post
  resources :orders
end
