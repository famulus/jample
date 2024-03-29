Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'
  root 'jample#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'


  get 'get_slice/:voice/:track_id/:start_onset_index/:stop_onset_index' => 'jample#get_slice'

  get 'get_slice/:voice/' => 'jample#get_slice'

  get 'voice/:id' => 'jample#voice'

  get 'youtube_dl/:youtube_id' => 'jample#youtube_dl'
  get 'recycle/:track_path' => 'jample#recycle'


  get 'mp3tag/:slice_id/:track_id' => 'jample#mp3tag'

  get 'back_one_audition/:voice/' => 'jample#back_one_audition'
  get 'forward_one_audition/:voice/' => 'jample#forward_one_audition'


  # Route for recent tracks by Sarah
  get 'get_recent_tracks' => 'jample#get_recent_tracks'

  # Route for drag and drop post by Sarah
  # TODO: Mark review
  get 'drag_and_drop' => 'jample#drag_and_drop'
  post 'drag_and_drop' => 'jample#drag_and_drop'

  get 'set_current_patch/:id' => 'jample#set_current_patch'
  post 'set_current_patch_set' => 'jample#set_current_patch_set'


  get 'randomize_current_patch' => 'jample#randomize_current_patch'

  get 'randomize_voice/:id' => 'jample#randomize_voice'

  post 'set_filter/' => 'jample#set_filter'
  post 'set_current_patch_set_name/' => 'jample#set_current_patch_set_name'
  post 'duplicate_patch_set/' => 'jample#duplicate_patch_set'

  post 'init_16_patches' => 'jample#init_16_patches'
  post 'shuffle_unfrozen' => 'jample#shuffle_unfrozen'
  post 'init_16_patches_as_sequence' => 'jample#init_16_patches_as_sequence'
  post 'init_16_patches_as_duration_sequence' => 'jample#init_16_patches_as_duration_sequence'
  post 'expand_single_patch_to_sequence' => 'jample#expand_single_patch_to_sequence'


  post 'shrink_patch_by_one_on_the_end/' => 'jample#shrink_patch_by_one_on_the_end'
  post 'grow_patch_by_one_on_the_end/' => 'jample#grow_patch_by_one_on_the_end'
  post 'shift_sample_backward_one_slice/' => 'jample#shift_sample_backward_one_slice'
  post 'shift_sample_forward_one_slice/' => 'jample#shift_sample_forward_one_slice'
  post 'nudge_sample_start_backward_milliseconds/' => 'jample#nudge_sample_start_backward_milliseconds'
  post 'nudge_sample_start_forward_milliseconds/' => 'jample#nudge_sample_start_forward_milliseconds'
  get 'set_volume/:volume' => 'jample#set_volume'

  get 'reset' => 'jample#reset'
  get 'all_patchsets' => 'jample#all_patchsets'
  get 'all_tracks' => 'jample#all_tracks'

  get 'freeze_patch/:id/:checkbox_status' => 'jample#freeze_patch'

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
