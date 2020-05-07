module SessionsHelper
  
  # 引数に渡されたユーザーオブジェクトでログインします。
  def log_in(user)
    session[:user_id] = user.id
    # ユーザーのブラウザ内にある一時的cookiesに暗号化済みのuser.idが自動で生成され、
    # session[:user_id]と記述することで元通りの値を取得することが可能
  end
  
  # セッションと@current_userを破棄します
  def log_out
    session.delete(:user_id)
    # sessionのuser_idを破棄
    @current_user = nil
    # current_user変数の中身もnilって破棄
  end
  
  # 現在ログイン中のユーザーがいる場合オブジェクトを返します。
  def current_user
    if session[:user_id] # sessions_helper.rbで変数を定義
      @current_user ||= User.find_by(id: session[:user_id])
      # @current_userかUser.find_by(id: session[:user_id])のどちらかにバリューがある場合
      # @current_userにそのバリューを入れる。
    end
  end
  
  # 現在ログイン中のユーザーがいればtrue、そうでなければfalseを返します。
  # current_userは空ですか？に否定演算子!が付いている
  def logged_in?
    !current_user.nil?
  end
  
end
