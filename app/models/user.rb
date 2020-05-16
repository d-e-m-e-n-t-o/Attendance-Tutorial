class User < ApplicationRecord
  
  has_many :attendances, dependent: :destroy
  # has_many :attendances(複数持つので複数形)でUserモデルがAttendanceモデルに対して、1耐多の
  # 関連性を示す。dependent: :destroyでユーザーが削除されたら、関連する勤怠データも同時に削除
  #されるよう設定する。この追加でユーザーを削除したのにけ勤怠データがデータベースに残らないよう
  # にしている。
  
  # 「remember_token」という仮想の属性を作成します。
  attr_accessor :remember_token
  
  before_save { self.email = email.downcase } # メールアドレスの大文字小文字を区別せず小文字として登録。
  #　before_saveメソッドに現在のメールアドレス（self.email）の値をdowncaseメソッドを使って小文字に変換。
  validates :name, presence: true, length: { maximum: 50 }# maximumは最大文字数制限
  # presence: trueで未入力を阻止。
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  # この↑正規表現でメールアドレスのフォーマットを検証出来る。
  # つまり 効なメールアドレスにだけマッチし、無効となるメールアドレスではマッチしなくなる。
  validates :email, presence: true, length: { maximum: 100 },
                    format: { with: VALID_EMAIL_REGEX },
                    # formatオプションは引数に正規表現(VALID_EMAIL_REGEX)を指定
                    uniqueness: true
                    # uniqueness: trueは一意性の検証を行っている。一意とは(他に同じデータがない)ということ
  validates :department, length: { in: 2..30 }, allow_blank: true
  # in: 2..30は入力された文字が2文字以上３０文字以下。
  # allow_blank: trueは対象の値がblank? => trueの場合にバリデーションをスキップ。つまり値が空文字""の
  # 場合バリデーションをスルー
  
  validates :basic_time, presence: true
  validates :work_time, presence: true
  
has_secure_password
# Userモデル(schemaファイル)にpassword_digestカラムを追加し、bcryptをgemファイルに追加して使えるようになる
# has_secure_passwordがやってくれること
# ・モデルにpassword属性とpassword_confirmation属性の追加
# ・それら属性のvalidation(存在性とそれら属性値の一致を検証)
# ・authenticateメソッドの追加
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  # minimumは最小文字数制限
  # ユーザー編集ページでパスワード未入力でも更新出来るよう、allow_nil: trueオプションを使う。対象の値が
  # nilの場合にバリデーションをスキップ出来る。has_secure_passwordがオブジェクト生成時に存在性を検証する
  # ようになっているので、問題なく動作する。

  # ハッシュ化する処理、渡された文字列のハッシュ値を返す。入れる値が同じなら、ハッシュ値も同じ
  def User.digest(string)
    cost = 
      if ActiveModel::SecurePassword.min_cost
        BCrypt::Engine::MIN_COST
      else
        BCrypt::Engine.cost
      end
    BCrypt::Password.create(string, cost: cost)
  end
  # 値を入れるとランダムな値に変換してくれる処理
  def User.new_token
    SecureRandom.urlsafe_base64
  end
  
  # 永続セッションのためハッシュ化したトークンをデータベースに記憶します。
  def remember
    self.remember_token = User.new_token
    # User.new_tokenで生成した「ランダムな文字列を」selfを用いてremember_tokenに代入している。
    # seifがないと、単純にremember_tokenというローカル変数が作成されてしまう。
    update_attribute(:remember_digest, User.digest(remember_token))
    # remember_tokenの値がUser.digest(remember_token)に渡されUser.digest(string)が発動し
    # ハッシュ化される。update_attributeメソッドを使ってremember_digestを更新する。
    # update_attributeはバリデーションを無死することが出来る。
  end
  
  # cookiesに保存されているremember_tokenがデータベースにあるremember_digestと一致するかを確認。
  def authenticated?(remember_token)
    # authenticated?の?はメソッド名の一部で真偽値を返すタイプのメソッドに用いる。
    return false if remember_digest.nil?
    # remember_digestが存在しない場合はfalseを返して終了。勤怠チュートリアル7.2を参照。
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
  
  #remember_digestをnilに更新することでデータベースのログイン情報を破棄している。
  def forget
    update_attribute(:remember_digest, nil)
  end
  
end