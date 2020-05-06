class AddIndexToUsersEmail < ActiveRecord::Migration[5.1]
  def change
    add_index :users, :email, unique: true
    # データベースusersのemailカラムにインデックスを追加しunique: trueオプションを指定している。
    #インデックスを作成することでテーブルとは別に検索用に最適化された状態で必要なデータだけがテーブルとは別に保存される。
  end
end
