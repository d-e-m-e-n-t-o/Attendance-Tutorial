class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user, only: [:show, :edit, :update, :destroy]
  # before_actionメソッドで:show, :edit, :updateアクションのにlogged_in_userメソッドを実行する。
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy
  
  def index
    @users = User.paginate(page: params[:page])
    # @users = User.allを上記に書き換える。paginateではキーが:pageで値がページ番号のハッシュを引数にする。
    # User.paginateは:pageパラメータに基づき、データベースからひとかたまりのデータを取出来る。デフォルトで
    # 30件で、設定や個別に指定可能です
  end  
  
  def show
    @user = User.find(params[:id])
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
       log_in @user # 保存成功後、ログインします。
      flash[:success] = '新規作成に成功しました。'
      # flashにsuccessというハッシュキーを持たせて
      redirect_to @user 
      # redirect_to user_url(@user)と同じ、省略しているだけ(この場合/users/のshow.html.erbに対応)
    else
      render :new
    end
  end
  
  # webページから送信されたparamsハッシュのidを使ってユーザーテーブルを検索し、
  # ヒットしたルートをを@userに入れる。
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      # update_attributesメソッドはrailsのモデルに備わっているメソッドでupdate_attributes(キー: 値, キー: 値 … )
      # のようにハッシュを引数に渡してデータベースのレコードを複数同時に更新することができるメソッド。
      flash[:success] = "ユーザー情報を更新しました。"
      # flashメッセージはいわばハッシュなのでkeyとvalueを設定する。
      redirect_to @user
    else
      render :edit
    end
  end
  
  def destroy
    @user.destroy
    flash[:success] = "#{@user.name}のデータを削除しました。"
    redirect_to users_url
  end
  
  private
  # 下記のuser_paramsメソッドはUsersコントローラの内部でのみ実行出来ればよいので、
  # privateキーワードを用いて外部からは使用できないようにする。
  # 悪質な攻撃によりアプリケーションのデータベースが書き換えられないように対策を取ることが目的
  
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
    # paramsハッシュでは:userキーを必須とし:name, :email, :password, :password_confirmation
    # をそれぞれ許可しそれ以外は許可しない。:userキーがない場合はエラーになる。
  end
  
  # before_actionメソッドで使用するためのメソッド↓
  
  # paramsハッシュからユーザーを取得します。
  def set_user
    @user = User.find(params[:id])
  end
  
  # ユーザーがログインしているか確認する。
  def logged_in_user
      unless logged_in?
      # unlessは条件式がfalseの場合のみ記述した処理が実行される。ifの逆やね！
        store_location
        flash[:danger] = "ログインしてください。"
        redirect_to login_url
      end
  end
  
  # :edit, :updateアクションを実行するユーザーが現在ログインしているユーザーか確認する。
  def correct_user
      redirect_to(root_url) unless current_user?(@user)
      # ここの@userはset_userメソッドで値を指定
      
  end
  
  # システム管理権限所有かどうか判定します。
    def admin_user
      redirect_to root_url unless current_user.admin?
    end
  
end