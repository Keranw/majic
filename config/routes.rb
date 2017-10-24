Rails.application.routes.draw do
  get 'myfilters/index'

  post 'myfilters/:id/delete', to: "myfilters#delete", as: "myfilters_delete"

  get 'myfilters/add'
  get 'myfilters/update'

  #get 'images/index'

  #get 'images/new'

  #get 'images/create'

  #get 'images/destory'

  get '/images/filter' , :to => "images#filter"

  get '/images/changeFormat/:image_id/:filter_id', to: 'images#changeFormat', as: "change_image_format"
  get '/images/reEdit/:image_id/:filter_id/:appliedFilters', to: 'images#reEdit', as: "image_reEdit"
  get '/images/save/:image_id/:appliedFilters', to: 'images#save', as: "image_save"
  get 'images/saveToDB'
  get 'images/trashbin'

  post 'images/:id/trash', to: "images#trash", as: "image_trash"

  post 'images/:id/restore', to: "images#restore", as: "image_restore"

  post 'images/share', to: "images#share", as: "image_share"

  get 'images/download/:id', to: "images#download", as: "image_download"

  get 'images/shareIndex'
  get '/images/view/:image_id', to: 'images#view', as: "image_view"


  get 'homepage/index'

  post 'images/cleartrash', to: "images#cleartrash", as: "images_cleartrash"

  # get '/images/edit/:id', to: 'images#edit'
  root 'homepage#index'

  get 'help'    => 'homepage#help'
  get 'about'   => 'homepage#about'
  get 'contact' => 'homepage#contact'

  resources :images, only: [:index, :new, :create, :destroy, :edit]
  devise_for :users

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
