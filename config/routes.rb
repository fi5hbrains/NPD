Rails.application.routes.draw do
  
  match '/', to: 'page#index', via: [:get, :post], as: 'root'

  resources :comments, only: [:create, :update, :destroy], path: 'comment'
  
  post 'vote/:votable_type/:votable_id', to: 'users#vote', as: 'vote'
  post 'note/:polish_id', to: 'polishes#note', as: 'note'
  post 'collect/:polish_id', to: 'polishes#collect', as: 'collect'
  post 'lock/:polish_id', to: 'polishes#lock', as: 'lock'
  post 'get_invite', to: 'users#get_invite'
  post 'switch/:switch/:option', to: 'user_sessions#switch', as: 'switch'
  patch 'boxes/:id', to: 'boxes#update', as: 'update_box'
  get 'find_related', to: 'polishes#find_related'
  get 'search', to: 'application#search'
  get 'reorder', to: 'polishes#reorder'
  get 'lab_search', to: 'application#lab_search'
  get 'autocomplete', to: 'application#autocomplete'
  get 'bottling_status/:id', to: 'polishes#get_bottling_status', as: 'get_bottling_status'

  scope '/catalogue' do
    get '/', to: 'polishes#index', as: 'catalogue'
    constraints(id: /[^\/]+/) do
      get ':brand_id', to: 'brands#show', as: 'catalogue_brand'
      get ':brand_id/:polish_id', to: 'polishes#show', as: 'catalogue_brand_polish'
    end
  end
  
  scope '/lab' do
    constraints(id: /[^\/]+/) do
      resources :brands    , lab: 'true', param: 'brand_id', path: '' 
      resources :brands    , lab: 'true', only: [], path: '' do
        resources :polishes, lab: 'true', except: :index, param: 'polish_id', path: ''
        resources :polishes, lab: 'true', only: [], param: 'polish_id', path: '' do
          get :redress     , lab: 'true', on: :member
          get 'versions'   , lab: 'true', to: 'polish_versions#index', on: :member
          post :clone, on: :member
        end
        resources :bottles , lab: 'true', except: :index
      end
    end
  end

  resource :user_session, only: [:create, :destroy]
  
  constraints(id: /[^\/]+/) do
    resources :users, param: 'user_id', except: [:index, :create, :new], path: '' do
      get 'tags/:tag', to: 'entries#index', as: 'tag', on: :member
    end
    resources :users, path: '', only: [] do
      resources :boxes, except: [:index, :edit], path: '' do
        get :import, on: :member
        post :import, on: :member
        get :gather, on: :member
        get :edit, on: :member, to: 'boxes#show', edit: true
      end
      resources :followings, only: [:create, :destroy]
      resources :entries, path: 'diary' do
        post :like, on: :member          
      end    
    end
  end  
  
end
