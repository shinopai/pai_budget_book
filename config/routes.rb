Rails.application.routes.draw do
  # 認証ユーザー
  devise_for :users

  # ユーザーダッシュボード
  get "dashboard", to: "dashboard#index"

  # ルート
  root "dashboard#index"

  get "up" => "rails/health#show", as: :rails_health_check

  # 管理者ダッシュボード
  namespace :admin do
  get "/", to: "dashboard#index"
  resources :users, only: %i[index show]
  end
end


  # Defines the root path route ("/")
  # root "posts#index"
