Rails.application.routes.draw do

  root 'challenges#index'

  get 'sent_emails' => 'sent_emails#index'
  get 'sent_emails/:id' => 'sent_emails#show', as: :sent_email

  resources :event_logs

  resources :scaffolds

  resources :challenges do
    resources :weeks
    delete 'clear_weeks' => 'weeks#clear', as: :clear_weeks
    post 'bulk' => 'weeks#bulk_post', as: :bulk_post
    get 'bulk' => 'weeks#bulk_add', as: :bulk_add
    put 'flickr_update' => 'challenges#flickr_update', as: :flickr_update
    get 'flickr_check_photos' => 'challenges#flickr_check_photos', as: :flickr_check_photos
    put 'send_email/:id' => 'challenges#send_email', as: :send_email
    put 'remove_member/:id' => 'challenges#remove_member', as: :remove_member

    # Membership
    resources :members
  end


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
