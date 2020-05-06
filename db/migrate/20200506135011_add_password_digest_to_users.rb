# パスワードを実装するためのマイグレーションファイル
# 詳しくは勤怠チュートリアルの4.5パスワードを追加しようを見て
class AddPasswordDigestToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :password_digest, :string
  end
end
