class UsersController < ApplicationController
  
  def show
    @user = User.find(params[:id])
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = '新規作成に成功しました。'
      # flashにsuccessというハッシュキーを持たせて
      redirect_to @user # redirect_to user_url(@user)と同じ、省略しているだけ
    else
      render :new
    end
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
end
