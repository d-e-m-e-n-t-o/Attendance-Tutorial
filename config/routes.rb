Rails.application.routes.draw do
  get 'sessions/new'

  root 'static_pages#top'
  get '/signup', to: 'users#new'
  
  #ログイン機能(Sessionsリソースではフルセットは必要ないことと、
  #URLを名義上わかりやすくするために必要なルーティングのみを直接記述)
  get '/login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  
  # userに関するルーティングを設定
  resources :users do
  # resourcesは指定したテーブルにに対して複数のルーティングが定義されます
  #4つの基本操作（POST GET PATCH DELETE）に対してルーティングが設定される。
  #超絶便利！！！！！！！！！！！！
  
  # 基本情報編集ページをモーダルウインドウで表示させるため、memberブロックをリソースブロックに追加
    member do
        get 'edit_basic_info'
        patch 'update_basic_info'
        get 'attendances/edit_one_month'
        # コントローラーをattendancesとする為、記述を追加。
        patch 'attendances/update_one_month'
    end
    resources :attendances, only: :update
    # AttendancesリソースとしてはupdateアクションのみでOKなのでonlyオプションで指定することで、
    # ルーティングを制限する。またUsersリソースのブロック内に記述しているため、設定される
    # ルーティングはUsersが関連したものになる。これでparams[:user_id]でユーザーIDが取得できる。
  end
  

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
