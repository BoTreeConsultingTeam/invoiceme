Rails.application.routes.draw do

  get 'home/index'
  resources :clients
  resources :company
  resources :items
  devise_for :users, controllers: {registrations: 'registrations'}
  devise_scope :user do
    get '/login' => 'devise/sessions#new'
    get '/logout' => 'devise/sessions#destroy'
  end

  get '/user/change_password' => 'user#change_password', as: :change_password
  post '/user/update_password' => 'user#update_password', as: :update_password
  resources :user, :controller => "user"
  resources :invoices

  post '/user' => 'user#create', as: :user_create_path
  put '/user/:id' => 'user#update', as: :user_update_path
  post '/items/populate_values_of_item' => "items#populate_values_of_item", as: :populate_values_of_item_path
  post '/clients/:id/address' => "clients#address"
  post '/invoices/pdf_generation/:id' => "invoices#pdf_generation", as: :invoice_generate_pdf
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  resources :invoices do
    resources :payments
  end
  # You can have the root of your site routed with "root"
  root 'home#index'

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
