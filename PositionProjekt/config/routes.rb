Rails.application.routes.draw do
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
  resource :users do
    resources :apps
  end
  resource :users
  resources :apps

  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do

      resources :events #:api/v1/events
      resources :users
      resources :tags



    end
  end


  post 'login' => "users#login", as: :login
  get 'login' => "users#index" #Gör att man kommer till låginsidan om man refreshar (markera url + enter)...
  get 'adminlogin' => "users#backendloginindex", as: :backlogin
  post 'adminlogin' => "users#backendlogin"
  get 'adminbase' => "users#backendIndex", as: :backendIndex
  post 'create' => "users#create", as: :create

  get 'logout' => 'users#logout', as: :logout

  get 'beforeindex' => 'apps#beforeIndex', as: :beforeIndex

  root to: "users#index"

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
  #     # (apps/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
