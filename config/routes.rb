Medusa::Application.routes.draw do
  get "surfaces/index"
  get "surfaces/show"
  devise_for :users, controllers: {
               omniauth_callbacks: "users/omniauth_callbacks",
               registrations: "users"
             }

  root 'records#index'

  concern :bundleable do
    collection do
      post :bundle_edit
      post :bundle_update
    end
  end

  concern :reportable do
    member do
      get :download_card
      get :download_label
    end
    collection do
      get :download_bundle_card
      get :download_bundle_label
    end
  end

  concern :link_by_global_id do
    collection do
      post :link_by_global_id
    end
  end
  
  concern :inventory do
    member do
      post :inventory
    end
  end

  concern :multiple do
    collection do
      get :multiple_new
      post :multiple_create
    end
  end
  
  concern :sesar_upload do
    member do
      post :sesar_upload
    end
  end

  resources :records, { id: /((?!\.(html$|json$|xml$|pml$)).)*/ } do
    member do
      get 'record_property' => 'records#property'
      get 'casteml'
      get 'ancestors'
      get 'descendants'
      get 'self_and_descendants'      
      get 'root'
      get 'parent'      
      get 'daughters'
      get 'siblings'
      get 'self_and_siblings'
      get 'families'      
    end
  end

  resources :specimens, concerns: [:bundleable, :reportable, :sesar_upload], except: [:new] do
    member do
      get :family
      get :picture
      get :map
      get :property
      get :detail_edit
      get :chemistries
      get :place, to: :show_place
      post :place, to: :create_place
    end
    resource :record_property, only: [:show, :update], defaults: { parent_resource: "specimen" }
    resources :attachment_files, concerns: [:link_by_global_id], only: [:index, :create, :update, :destroy], controller: "nested_resources/attachment_files", defaults: { parent_resource: "specimen" }
    resources :bibs, concerns: [:link_by_global_id], only: [:index, :create, :update, :destroy], controller: "nested_resources/bibs", defaults: { parent_resource: "specimen" }
    resources :daughters, concerns: [:link_by_global_id], only: [:index, :create,:update, :destroy], controller: "nested_resources/specimens", defaults: { parent_resource: "specimen", association_name: "children" }
    resources :specimens, concerns: [:link_by_global_id], only: [:index, :update, :destroy], controller: "nested_resources/specimens", defaults: { parent_resource: "specimen", association_name: "children" }
    resources :analyses, concerns: [:link_by_global_id], only: [:index,:create, :update, :destroy], controller: "nested_resources/analyses", defaults: { parent_resource: "specimen" }
  end

  resources :boxes, concerns: [:bundleable, :reportable], except: [:new] do
    member do
      get :family
      get :picture
      get :property
    end
    resource :record_property, only: [:show, :update], defaults: { parent_resource: "box" }
    resources :attachment_files, concerns: [:link_by_global_id], only: [:index, :create, :update, :destroy], controller: "nested_resources/attachment_files", defaults: { parent_resource: "box" }
    resources :bibs, concerns: [:link_by_global_id], only: [:index, :create, :update, :destroy], controller: "nested_resources/bibs", defaults: { parent_resource: "box" }
    resources :specimens, concerns: [:link_by_global_id, :inventory], only: [:index, :create, :update, :destroy], controller: "nested_resources/specimens", defaults: { parent_resource: "box", association_name: "specimens" }
    resources :boxes, concerns: [:link_by_global_id, :inventory], only: [:index, :create, :update, :destroy], controller: "nested_resources/boxes", defaults: { parent_resource: "box", association_name: "children" }
  end

  resources :places, concerns: [:bundleable, :reportable] do
    member do
      get :map
      get :property
    end
    collection do
      post :import
    end
    resource :record_property, only: [:show, :update], defaults: { parent_resource: "place" }
    resources :attachment_files, concerns: [:link_by_global_id],only: [:index, :create, :update, :destroy], controller: "nested_resources/attachment_files", defaults: { parent_resource: "place" }
    resources :bibs, concerns: [:link_by_global_id], only: [:index, :update, :destroy], controller: "nested_resources/bibs", defaults: { parent_resource: "place" }
    resources :specimens, concerns: [:link_by_global_id], only: [:index, :create, :update, :destroy], controller: "nested_resources/specimens", defaults: { parent_resource: "place", association_name: "specimens" }
  end

  resources :analyses, concerns: :bundleable do
    member do
      get :picture
      get :property
      get :casteml
    end
    collection do
      post :import
      get :table
      get :castemls
    end
    resource :record_property, only: [:show, :update], defaults: { parent_resource: "analysis" }
    resources :attachment_files, concerns: [:link_by_global_id], only: [:index, :create, :update, :destroy], controller: "nested_resources/attachment_files", defaults: { parent_resource: "analysis" }
    resources :bibs, concerns: [:link_by_global_id], only: [:index, :create, :update, :destroy], controller: "nested_resources/bibs", defaults: { parent_resource: "analysis" }
    resources :chemistries, concerns: [:multiple],only: [:index, :create, :update, :destroy], controller: "nested_resources/chemistries"
  end

  resources :bibs, concerns: [:bundleable, :reportable], except: [:new] do
    member do
      get :picture
      get :property
    end
    collection do
      get :download_to_tex
    end
    resource :record_property, only: [:show, :update], defaults: { parent_resource: "bib" }
    resources :specimens, concerns: [:link_by_global_id], only: [:index, :create, :update, :destroy], controller: "nested_resources/specimens", defaults: { parent_resource: "bib", association_name: "specimens" }
    resources :boxes, concerns: [:link_by_global_id], only: [:index, :create, :update, :destroy], controller: "nested_resources/boxes", defaults: { parent_resource: "bib", association_name: "boxes" }
    resources :places, concerns: [:link_by_global_id], only: [:index, :create, :update, :destroy], controller: "nested_resources/places", defaults: { parent_resource: "bib", association_name: "places" }
    resources :analyses, concerns: [:link_by_global_id], only: [:index, :create, :update, :destroy], controller: "nested_resources/analyses", defaults: { parent_resource: "bib", association_name: "analyses" }
    resources :attachment_files, concerns: [:link_by_global_id], only: [:index, :create, :update, :destroy], controller: "nested_resources/attachment_files", defaults: { parent_resource: "bib" }
    resources :tables, concerns: [:link_by_global_id], only: [:index,:create, :update, :destroy], controller: "nested_resources/tables", defaults: { parent_resource: "bib" }
  end

  resources :surfaces, concerns: [:bundleable, :reportable] do
    member do
      get :family
      get :picture
      get :property
    end
    resources :images, concerns: [:link_by_global_id], only: [:index, :show, :create, :update, :destroy], controller: "surface_images" do
      member do
        post 'move_to_top'
      end
    end
  end

  resources :tables, except: [:new] do
    member do
      get :property
    end
    resource :record_property, only: [:show, :update], defaults: { parent_resource: "place" }
    resources :specimens, concerns: [:link_by_global_id], only: [:index, :create, :update, :destroy], controller: "nested_resources/specimens", defaults: { parent_resource: "table", association_name: "specimens" }
  end

  resources :attachment_files, concerns: :bundleable , except: [:new] do
    member do
      get :property
      get :picture
      get :download
    end
    resource :record_property, only: [:show, :update], defaults: { parent_resource: "attachment_file" }
    resources :spots, only: [:index, :create, :update, :destroy], controller: "nested_resources/spots"
    resources :places, concerns: [:link_by_global_id], only: [:index, :create, :update, :destroy], controller: "nested_resources/places", defaults: { parent_resource: "attachment_file", association_name: "places" }
    resources :specimens, concerns: [:link_by_global_id], only: [:index, :create, :update, :destroy], controller: "nested_resources/specimens", defaults: { parent_resource: "attachment_file", association_name: "specimens" }
    resources :boxes, concerns: [:link_by_global_id], only: [:index, :create, :update, :destroy], controller: "nested_resources/boxes", defaults: { parent_resource: "attachment_file", association_name: "boxes" }
    resources :bibs, concerns: [:link_by_global_id], only: [:index, :create, :update, :destroy], controller: "nested_resources/bibs", defaults: { parent_resource: "attachment_file" }
    resources :analyses, concerns: [:link_by_global_id], only: [:index, :create, :update, :destroy], controller: "nested_resources/analyses", defaults: { parent_resource: "attachment_file" }
  end

  resources :chemistries , only: [:edit, :update] do
    resource :record_property, only: [:show, :update], defaults: { parent_resource: "chemistry" }
  end

  resources :spots, only: [:index, :show, :edit, :update] do
    member do
      get :family
      get :property
      get :picture
    end
    resource :record_property, only: [:show, :update], defaults: { parent_resource: "spot" }
  end

  resource  :system_preference, only: [:show]
  resource  :account, only: [:show, :edit, :update] do
    member do
      get 'find_by_global_id'
      post 'unlink'
      get 'groups'
    end
  end
  resources :users
  resources :groups, except: [:new]
  resources :physical_forms, except: [:new]
  resources :classifications, except: [:new]
  resources :box_types, except: [:new]
  resources :measurement_items, except: [:new]
  resources :measurement_categories, except: [:new] do
    member do
      post 'duplicate'
    end
  end
  resources :category_measurement_items, only: [:destroy] do
    member do
      post 'move_to_top'
    end
  end
  resources :attachings  do
    member do
      post 'move_to_top'
    end
  end
  resources :units, except: [:new]
  resources :techniques, except: [:new]
  resources :authors, except: [:new]
  resources :devices, except: [:new]
  resources :qrcodes, id: /((?!\.(html$|json$|xml$)).)*/, only: [:show]
  resources :custom_attributes, except: [:new]

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
