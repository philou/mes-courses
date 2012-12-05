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

  mount Blogit::Engine => "/blog", as: 'blog'

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

  # blog migration(radiant -> blogit) redirections
  get "/blog/2010/12/06/le-problme-avec-les-courses-alimentaires", to: redirect("/blog/posts/23-le-probleme-avec-les-courses-alimentaires")
  get "/blog/2010/12/19/ma-technique-pour-faire-manger-du-poisson-notre-fils", to: redirect("/blog/posts/26-ma-technique-pour-faire-manger-du-poisson-a-notre-fils")
  get "/blog/2011/01/03/comment-prparer-les-girolles-en-fricasse-", to: redirect("/blog/posts/13-comment-preparer-les-girolles-en-fricassee")
  get "/blog/2011/01/22/comment-faire-ses-courses-rapidement", to: redirect("/blog/posts/7-comment-faire-ses-courses-rapidement")
  get "/blog/2011/02/02/un-rgime-pour-durer", to: redirect("/blog/posts/42-un-regime-pour-durer")
  get "/blog/2011/02/25/initier-les-enfants-informatique", to: redirect("/blog/posts/21-initier-les-enfants-a-l-informatique")
  get "/blog/2011/03/07/gigot-en-cuisson-lente", to: redirect("/blog/posts/20-gigot-en-cuisson-lente")
  get "/blog/2011/03/17/comment-nettoyer-son-four-micro-ondes-facilement", to: redirect("/blog/posts/9-comment-nettoyer-son-four-micro-ondes-facilement")
  get "/blog/2011/04/05/regaler-ses-enfants-avec-des-poissons-panes-maison", to: redirect("/blog/posts/36-regaler-ses-enfants-avec-des-poissons-panes-maison")
  get "/blog/2011/04/14/gateau-au-chocolat-de-nancy-flash-mc-queen", to: redirect("/blog/posts/19-gateau-au-chocolat-de-nancy-flash-mc-queen")
  get "/blog/2011/05/04/comment-emincer-des-echalotes", to: redirect("/blog/posts/6-comment-emincer-des-echalotes")
  get "/blog/2011/06/11/poisson-a-basse-temperature", to: redirect("/blog/posts/30-poisson-a-basse-temperature-sans-materiel-exhorbitant")
  get "/blog/2011/06/13/moules-a-la-provencale", to: redirect("/blog/posts/27-moules-a-la-provencale")
  get "/blog/2011/06/26/recevoir-sans-stress-avec-la-pre-cuisson", to: redirect("/blog/posts/34-recevoir-sans-stress-avec-la-pre-cuisson")
  get "/blog/2011/08/02/pommes-de-terres-roties-la-derniere-minute", to: redirect("/blog/posts/31-pommes-de-terres-roties-a-la-derniere-minute")
  get "/blog/2011/08/02/7-astuces-pour-gagner-du-temps-avec-la-sieste", to: redirect("/blog/posts/2-7-astuces-pour-gagner-du-temps-avec-la-sieste")
  get "/blog/2011/08/09/comment-reussir-sa-creme-patissiere-coup-sur", to: redirect("/blog/posts/15-comment-reussir-sa-creme-patissiere-a-coup-sur")
  get "/blog/2011/09/05/decongeler-rapidement-et-uniformement", to: redirect("/blog/posts/17-decongeler-rapidement-et-uniformement")
  get "/blog/2011/09/06/reussir-une-sauce-bechamel-rapidement", to: redirect("/blog/posts/39-reussir-une-sauce-bechamel-rapidement")
  get "/blog/2011/09/29/comment-mesurer-des-proportions-sans-balance-ni-verre-mesureur", to: redirect("/blog/posts/8-comment-mesurer-des-proportions-sans-balance-ni-verre-mesureur")
  get "/blog/2011/10/12/mariner-des-legumes-en-30-minutes", to: redirect("/blog/posts/25-mariner-des-legumes-en-30-minutes")
  get "/blog/2012/01/10/nous-avons-test-un-cybermarche", to: redirect("/blog/posts/28-nous-avons-teste-un-cybermarche")
  get "/blog/2012/02/27/reussir-une-sauce-au-beurre-blanc", to: redirect("/blog/posts/38-reussir-une-sauce-au-beurre-blanc")
  get "/blog/2012/03/26/comment-avoir-du-pain-frais-tous-les-jours", to: redirect("/blog/posts/4-comment-avoir-du-pain-frais-tous-les-jours")
  get "/blog/2012/04/09/ouverture-du-service-d-assistance-aux-courses", to: redirect("/blog/posts/29-ouverture-du-service-d-assistance-aux-courses")
  get "/blog/2012/05/28/comment-cuire-les-pommes-de-terre-encore-plus-vite", to: redirect("/blog/posts/5-comment-cuire-les-pommes-de-terre-encore-plus-vite")
  get "/blog/2012/07/11/gagnez-du-temps-avec-un-aspirateur-robot", to: redirect("/blog/posts/18-gagnez-du-temps-avec-un-aspirateur-robot")
  get "/blog/2012/07/18/quoi-de-neuf-sur-mes-courses-fr", to: redirect("/blog/posts/32-quoi-de-neuf-sur-mes-courses-fr")
  get "/blog/2012/07/25/5-etapes-pour-que-bebe-fasse-ses-nuits-completes", to: redirect("/blog/posts/1-5-etapes-pour-que-bebe-fasse-ses-nuits-completes")
  get "/blog/2012/08/02/comment-ouvrir-une-noix-de-coco", to: redirect("/blog/posts/11-comment-ouvrir-une-noix-de-coco")
  get "/blog/2012/08/14/salade-exotique", to: redirect("/blog/posts/40-salade-exotique")
  get "/blog/2012/08/24/comment-preparer-un-ananas-victoria", to: redirect("/blog/posts/14-comment-preparer-un-ananas-victoria")
  get "/blog/2012/08/29/reussir-les-croque-monsieurs-au-four", to: redirect("/blog/posts/37-reussir-les-croque-monsieurs-au-four")
  get "/blog/2012/09/12/quoi-de-neuf-sur-mes-courses-fr-septembre-2012", to: redirect("/blog/posts/33-quoi-de-neuf-sur-mes-courses-fr-septembre-2012")
  get "/blog/2012/09/19/comment-passer-l-hiver-sans-maladie", to: redirect("/blog/posts/12-comment-passer-l-hiver-sans-maladie")
  get "/blog/2012/09/26/stop-au-grignotage", to: redirect("/blog/posts/41-stop-au-grignotage")
  get "/blog/2012/10/03/le-roti-du-dimanche", to: redirect("/blog/posts/24-le-roti-du-dimanche")
  get "/blog/2012/10/10/cybermarche-pour-chiens-et-chats", to: redirect("/blog/posts/16-cybermarche-pour-chiens-et-chats")
  get "/blog/2012/10/24/kits-bebe-et-fruits-et-legumes-de-saison-sur-mes-courses-fr", to: redirect("/blog/posts/22-kits-bebe-fruits-et-legumes-de-saison-sur-mes-courses-fr")
  get "/blog/2012/10/31/recycler-un-vieil-ordinateur-pour-vos-enfants", to: redirect("/blog/posts/35-recycler-un-vieil-ordinateur-pour-vos-enfants")
  get "/blog/2012/11/08/comment-ouvrir-les-huitres", to: redirect("/blog/posts/10-comment-ouvrir-les-huitres")
  get "/blog/2012/11/22/auchan-hyper-ou-cyber-qui-est-le-moins-cher", to: redirect("/blog/posts/3-auchan-hyper-ou-cyber-qui-est-le-moins-cher")
  get "/blog/2012/12/05/gagnez-du-temps-et-de-l-argent-avec-les-abonnements-amazon", to: redirect("/blog/posts/43-gagnez-du-temps-et-de-l-argent-avec-les-abonnements-amazon")

end
