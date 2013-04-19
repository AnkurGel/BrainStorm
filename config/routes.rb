Brainstorm::Application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks", :registrations => "registrations" }, :path_names => { :sign_in => "login", :sign_out => "logout", :sign_up => "register" }
  devise_scope :user do
    get '/login', :to => "devise/sessions#new"
    get '/register', :to => "devise/registrations#new"
    match '/destroy/:id',  :to => 'registrations#destroy', :via => :delete, :as => 'user_destroy'
  end

  resources :levels, :only => [:create, :show, :update, :destroy]
  resources :attempts, :only => [:create]
  resources :colleges, :only => [:create]

  #root to: 'default_pages#home'
  root to: 'home_page#index'
  match '/home', :to => 'default_pages#home', :as => 'home'
  match '/leaderboard', :to => 'default_pages#fame', :as => 'fame'
  match '/admin',       :to => 'default_pages#admin'
  match '/analytics',   :to => 'default_pages#analytics'
  match '/contact',     :to => 'default_pages#contact'
  match '/team',        :to => 'default_pages#team'
  match '/rules',       :to => 'default_pages#rules'
  match '/policy',      :to => 'default_pages#policy'
  match '/levels/:id/edit', :to => 'default_pages#edit_question', :as => 'edit_level'
  match '/play',        :to => 'levels#play', :as => 'play'
  match '/user/:id',    :to => 'default_pages#view_attempts', :as => 'view_attempts'
  match '/observe', :to => 'default_pages#observe', :as => 'observe'
  match '/observe/:id', :to => 'default_pages#observe', :as => 'observe_get'
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
end
