Rails.application.routes.draw do
  # ログイン ログアウト
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy", as: 'logout'

  # トップページ
  root "home#index"

  # 開発・デバック用
  get "up", to: "rails/health#show", as: :rails_health_check
  get "service-worker", to: "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest", to: "rails/pwa#manifest", as: :pwa_manifest

  # user登録とフォーム送信用
  resources :users, only: %i[new create show index] do
    resources :battles,  only: %i[index] do
      collection do
        post 'increase' # /users/id/battles/increase
        post 'decrease'
        post 'save_score'
      end
    end
  end
end
