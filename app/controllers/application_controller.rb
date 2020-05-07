class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  # sessions_helper.rbにログインログイン処理のメソッドがまとめてある。これをコントローラーで使う場合、
  # モジュールを読み込ませる必要がある。全コントローラの親クラスであるこのコントローラーに、
  # モジュールを読み込ませることで、どのコントローラでも使えるようにしている。
end
