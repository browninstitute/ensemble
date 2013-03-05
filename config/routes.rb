StoryCollab::Application.routes.draw do

  resources :stories do
    collection do
      get 'current'
    end
    member do
      match 'preview'
      get 'history'
      get 'history/:version', :action => 'view_version', :as => 'version'
      get 'cancel_edit'
      get 'preview_submit'
    end
    resources :story_roles
    resources :posts do
      member do
        get 'reply'
      end
    end
  end

  resources :scenes do
    resources :comments 
    resources :paragraphs
  end

  devise_for :users, :controllers => { :registrations => "users/registrations", :omniauth_callbacks => "users/omniauth_callbacks" } do
    get "/users/change_password" => "users/registrations#change_password"
    put "/users/registrations/update_password" => "users/registrations#update_password"
    get "/users/edit_profile" => "users/registrations#edit_profile"
    put "/users/edit_profile" => "users/registrations#update_profile"
    get "/users/preferences" => "users/registrations#preferences"
    match 'users/preferences' => 'users/registrations#save_preferences', :via => :put
    get "/users/:id" => "users/profiles#show", :as => :user
  end

  match 'paragraphs/:id/like' => 'paragraphs#like', :as => :like_paragraph
  match 'paragraphs/:id/unlike' => 'paragraphs#unlike', :as => :unlike_paragraph
  match 'paragraphs/:id/winner' => 'paragraphs#winner', :as => :winner_paragraph
  match 'paragraphs/:id/unwinner' => 'paragraphs#unwinner', :as => :unwinner_paragraph
  
  # Non-model pages
  get "home/index"
  match '/about' => 'pages#about'
  match '/storyslam' => 'pages#competition'

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
  root :to => 'home#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
