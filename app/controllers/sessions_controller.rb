class SessionsController < ApplicationController
  def new
  end
  
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    # downcaseは大文字を小文字に変換するメソッド
    # find_byは指定した引数にマッチした最初のレコードを検索するメソッド
    if user && user.authenticate(params[:session][:password])
    # authenticateメソッドは暗号化されてないパスワードとpassword_digest属性
    # (見た目は暗号化されている)値の一致を検証してくれる。
      log_in user # sessions_helper.rbのlog_in(user)を呼び出す。
      debugger
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      # params[:session]の[:remember_me]が1の時remember(user)が発動、そうじゃない時はforget(user)
      # が発動。この書き方は三項演算子と呼ばれる、
      # [条件式] ? で真偽値を返す。(true)の場合実行される処理 : (false)の場合実行される処理
      redirect_to user
    else
      flash.now[:danger] = '認証に失敗しました。'
      # flash.nowはレンダリングが終わっているページでフラッシュメッセージを表示するメソッド
      # 「リダイレクトはしないがフラッシュを表示したい」時に使える
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    # logget_in?がtrueの場合のみlog_outメソッドが発動、両方ともsessions_helper.rbにある。
    flash[:success] = 'ログアウトしました。'
    redirect_to root_url
  end
end
