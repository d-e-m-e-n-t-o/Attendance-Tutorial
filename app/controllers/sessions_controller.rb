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
      log_in user
      redirect_to user
      
    else
      flash.now[:danger] = '認証に失敗しました。'
      # flash.nowはレンダリングが終わっているページでフラッシュメッセージを表示するメソッド
      # 「リダイレクトはしないがフラッシュを表示したい」時に使える
      render :new
    end
  end

  def destroy
    log_out
    flash[:success] = 'ログアウトしました。'
    redirect_to root_url
  end
end
