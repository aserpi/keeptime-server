Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      mount_devise_token_auth_for RegisteredUser.name, at: 'auth', skip: [:omniauth_callbacks], controllers: {
          sessions:  'api/v1/devise_token_auth_overrides/sessions',
          token_validations:  'api/v1/devise_token_auth_overrides/token_validations'
      }
      resources :users, only: :show do
        get 'workspaces'
        get 'relationships/workspaces', to: 'users#workspaces'
      end

      resources :workspaces, except: [:new, :edit] do
        member do
          get 'relationships/supervisor', to: 'workspaces#show_supervisor'
          patch 'relationships/supervisor', to: 'workspaces#update_supervisor'

          get 'users', to: 'workspaces#index_users'
          get 'relationships/users', to: 'workspaces#index_users'
          patch 'relationships/users', to: 'workspaces#users'
          post 'relationships/users', to: 'workspaces#users'
          delete 'relationships/users', to: 'workspaces#users'
        end
      end
      # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
    end
  end
end
