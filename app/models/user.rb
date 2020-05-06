class User < ApplicationRecord
  before_save { self.email = email.downcase } # メールアドレスの大文字小文字を区別せず小文字として登録。
  #　before_saveメソッドに現在のメールアドレス（self.email）の値をdowncaseメソッドを使って小文字に変換。
  validates :name, presence: true, length: { maximum: 50 }# maximumは最大文字数制限
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  # この↑正規表現でメールアドレスのフォーマットを検証出来る。
  # つまり 効なメールアドレスにだけマッチし、無効となるメールアドレスではマッチしなくなる。
  validates :email, presence: true, length: { maximum: 100 },
                    format: { with: VALID_EMAIL_REGEX },
                    # formatオプションは引数に正規表現(VALID_EMAIL_REGEX)を指定
                    uniqueness: true
                    # uniqueness: trueは一意性の検証を行っている。一意とは(他に同じデータがない)ということ
has_secure_password
# Userモデルにpassword_digestカラムを追加し、bcryptgemを追加して使えるようになる
validates :password, presence: true, length: { minimum: 6 }# minimumは最小文字数制限
end