class AddAdminToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :admin, :boolean, default: false
    # デフォルトで管理権限を持たないようdefault: falseを追加。
  end
end
