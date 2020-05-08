module SessionsHelper
  
  # 引数に渡されたユーザーオブジェクトでログインします。
  def log_in(user)
    session[:user_id] = user.id
    # ユーザーのブラウザ内にある一時的cookiesに暗号化済みのuser.idが自動で生成され、
    # session[:user_id]と記述することで元通りの値を取得することが可能
  end
  
  # cookiesにuser_idとuser.remember_tokenを永続的に記憶。（Userモデルを参照）
  def remember(user)
    user.remember # userに対してuser.rbのrememberメソッドを呼び出して使う。
    cookies.permanent.signed[:user_id] = user.id
    # permanentメソッドはcookiesに保存される、値(user.id)とその有効期限を設定して保存できる。
    # signedメソッドはuser.idを暗号化する為に使う。
    cookies.permanent[:remember_token] = user.remember_token
    # remember_tokenはuser.rbのrememberメソッドによってハッシュ化されているのでsignedは要らないぜ。
  end
  
  def forget(user)
    user.forget
    # userに対してuser.rbのforgetメソッドを発動。
    cookies.delete(:user_id)
    # cookiesの:user_idをdelete
    cookies.delete(:remember_token)
    # cookiesの:remember_tokenをdelete
  end
  
  # セッションと@current_userを破棄します
  def log_out
    forget(current_user)
    # forget(user)メソッドにcurrent_userを渡して発動。
    session.delete(:user_id)
    # sessionのuser_idを破棄
    @current_user = nil
    # current_user変数の中身もnilって破棄
  end
  
  # 現在ログイン中のユーザーがいる場合オブジェクトを返します。
  # それ以外の場合はcookiesに対応するユーザーを返します。
  def current_user
    if (user_id = session[:user_id]) # session[:user_id]はsessions_helper.rbで変数を定義
      @current_user ||= User.find_by(id: user_id)
      # @current_userかUser.find_by(id: user_id)のどちらかにバリュー(値)がある場合
      # @current_userにそのバリュー(値)を入れる。
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end
  
  # 現在ログイン中のユーザーがいればtrue、そうでなければfalseを返します。
  # current_userは空じゃなかったらtrueに否定演算子!が付いている
  def logged_in?
    !current_user.nil?
  end
  
end
