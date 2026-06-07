Rails.application.routes.draw do
  devise_for :users

  # ユーザーダッシュボード
  get "dashboard", to: "dashboard#index"

  # ユーザーアセット
  resource :asset, only: %i[edit update]

  # ユーザー取引
  resources :transactions do
    get :copy, on: :member
  end

  # ユーザーテンプレート
  resources :templates, except: %i[new create show]

  # ユーザーカテゴリー
  resources :categories
  resources :sub_categories

  # ルート
  root "dashboard#index"

  get "up" => "rails/health#show", as: :rails_health_check

  # 管理者ダッシュボード
  namespace :admin do
    get "/", to: "dashboard#index"
    resources :users, only: %i[index show]
    resources :categories
    resources :sub_categories
  end
end
