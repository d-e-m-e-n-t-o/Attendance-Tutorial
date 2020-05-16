class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :edit_basic_info, :update_basic_info]
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy, :edit_basic_info, :update_basic_info]
  # before_actionメソッドで:show, :edit, :updateアクションのにlogged_in_userメソッドを実行する。
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:destroy, :edit_basic_info, :update_basic_info]
  before_action :set_one_month, only: :show
  
  def index
    @users = User.paginate(page: params[:page])
    # @users = User.allを上記に書き換える。paginateではキーが:pageで値がページ番号のハッシュを引数にする。
    # User.paginateは:pageパラメータに基づき、データベースからひとかたまりのデータを取出来る。デフォルトで
    # 30件で、設定や個別に指定可能です
  end  
  
  def show
    @worked_sum = @attendances.where.not(started_at: nil).count
    # @attendancesのstarted_atがnilではない要素を全て探し要素数を返して@worked_sumに入れる。
    # whereメソッドは条件にマッチしたレコードを全て返す。
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
   # @user = User.find(params[:id])
  end
  
  def update
    # @user = User.find(params[:id])
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
  
  def edit_basic_info
  end

  def update_basic_info
    if @user.update_attributes(basic_info_params)
      flash[:success] = "#{@user.name}の基本情報を更新しました。"
    else
      flash[:danger] = "#{@user.name}の更新は失敗しました。<br>" + @user.errors.full_messages.join("<br>")
      # full_messages.join("<br>")でエラーメッセージの配列の各要素を区切る際は<br>を使用するよう設定。
    end
      redirect_to users_url
  end
  
  private
  # 下記のuser_paramsメソッドはUsersコントローラの内部でのみ実行出来ればよいので、
  # privateキーワードを用いて外部からは使用できないようにする。
  # 悪質な攻撃によりアプリケーションのデータベースが書き換えられないように対策を取ることが目的
  
  def user_params
    params.require(:user).permit(:name, :email, :department, :password, :password_confirmation)
    # paramsハッシュでは:userキーを必須とし:name, :email, :password, :password_confirmation
    # をそれぞれ許可しそれ以外は許可しない。:userキーがない場合はエラーになる。
  end
  
  def basic_info_params
  params.require(:user).permit(:department, :basic_time, :work_time)
  # 、、、11. 2 StrongParametersの応用を確認して、、、も分からないと思うけどｗ
  
  end

end