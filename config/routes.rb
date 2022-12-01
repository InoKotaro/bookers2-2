Rails.application.routes.draw do

  devise_for :users
  root to:  'homes#top'
  get "/home/about" => "homes#about", as: "about"
  get "search" => "searches#search"#検索機能
  get "search_result" => "searches#search_result"


  resources :users, only:[:show, :index, :edit, :update] do
    resource :relationships, only:[:create, :destroy]#フォロー
    get 'followings' => 'relationships#followings', as: 'followings'
    get 'followers' => 'relationships#followers', as: 'followers'
  end

  resources :books, only:[:new, :create, :show, :index, :edit, :update, :destroy] do
    resources :comments, only:[:create, :destroy]#コメント
    resource :favorites, only:[:create, :destroy]#いいね
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end