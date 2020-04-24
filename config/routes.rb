Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      mount_devise_token_auth_for RegisteredUser.name, at: 'auth', skip: [:omniauth_callbacks], controllers: {
          sessions:  'api/v1/devise_token_auth_overrides/sessions',
          token_validations:  'api/v1/devise_token_auth_overrides/token_validations'
      }
      resources :registered_users, only: :show

      resources :workspaces, except: [:new, :edit]
      # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
    end
  end
end
