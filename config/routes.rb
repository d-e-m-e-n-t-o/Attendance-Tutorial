Rails.application.routes.draw do
  root 'static_pages#top'
  get '/signup', to: 'users#new'
  resources :users
  # resourcesは指定したテーブルにに対して複数のルーティングが定義されます
  #4つの基本操作（POST GET PATCH DELETE）に対してルーティングが設定される。
  #超絶便利！！！！！！！！！！！！

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
