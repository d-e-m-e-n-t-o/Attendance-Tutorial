class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  # sessions_helper.rbにログインログイン処理のメソッドがまとめてある。これをコントローラーで使う場合、
  # モジュールを読み込ませる必要がある。全コントローラの親クラスであるこのコントローラーに、
  # モジュールを読み込ませることで、どのコントローラでも使えるようにしている。
  
  # 曜日を取得する。
  $days_of_the_week = %w{日 月 火 水 木 金 土}
  # 変数days_of_the_weekに$を付けることで、グローバルにする。グローバル変数はプログラムの
  #どこからでも呼び出すことが出来る変数。
  # %w{日 月 火 水 木 金 土}は["日", "月", "火", "水", "木", "金", "土"]と同じ意味、シンプルに書ける。
  # ページ出力前に1ヶ月分のデータの存在を確認・セットします。
  
  def set_one_month
    @first_day = params[:date].nil? ?
    Date.current.beginning_of_month : params[:date].to_date
    # Date.currentで当日を取得しbeginning_of_monthを繋げことで当月の初日を取得。
    # params[:date]はstring型なのでto_dateでデータの型を日付に変換。
    @last_day = @first_day.end_of_month
    # @first_dayからend_of_monthで当月の終日を取得。@first_dayを使うことで
    # Date.currentを2回使わずに済む。
    # 範囲オブジェクトとして扱う場合(@first_day..@last_day)と記述
    # 配列として扱う場合[*@first_day..@last_day]と記述
    one_month = [*@first_day..@last_day]
    # @first_dayと@last_dayから1ヶ月分のオブジェクトを生成しローカル変数に代入。
    @attendances = @user.attendances.where(worked_on: @first_day..@last_day).order(:worked_on)
    # ＠userは定義されていないように見えるが、ユーザーコントローラー内のbefore_actionでset_user
    # が定義されている。このset_userをset_one_monthよりも上に記述することでbefore_actionの中でも
    # 優先的に実行されるので問題なし。
    # @user.attendances.where(worked_on: @first_day..@last_day)のattendancesでUserモデルに紐付く
    # モデルを指定している。(ActivbeRecord特有の記法)UserモデルとAttendanceモデルは1対多の
    # 関係なので、複数形となる。さらに@user.attendancesに対し、whereメソッドを呼び出し引数に
    # worked_onをキーとして定義済みのインスタンス変数を範囲として指定し1ヶ月分のユーザーに
    # 紐付く勤怠データを検索し取得する

    unless one_month.count == @attendances.count
    # unlessはfalseの時、下記の処理を実行する。それぞれの条件式でcountメソッドを呼び出している。
    # countメソッドは対象のオブジェクトが配列の場合、要素数を返す。これにより、1ヶ月分の日付の件数と
    # 勤怠データの件数が一致するか検証している。
      ActiveRecord::Base.transaction do 
        # transactionはまとめてデータを保存や更新するときに、全部成功したことを保証するための
        # 機能で万が一途中で失敗した時は、エラー発生時専用のプログラム部分までスキップする。
        one_month.each { |day| @user.attendances.create!(worked_on: day) }
        # one_monthの日付データを１つずつブロック変数dayにいれて
        # @user.attendances.create!(worked_on: day)を実行している。
        # createメソッドによってworked_onに日付の値が入ったAttendanceモデルのデータが
        # 生成される。
      end
       @attendances = @user.attendances.where(worked_on: @first_day..@last_day).order(:worked_on)
       # ここでも@attendancesを定義している、これは実際に日付データを繰り返し処理で生成した後にも、
       # 正しく@attendances変数に値が代入されるようにするため。orderメソッドは取得したデータを
       # 並び替えるメソッドでorder(:worked_on)で取得したAttendanceモデルの配列をworked_onの値を
       # もとに昇順に並び替える。
    end

  # トランザクションによるエラーの分岐です。
  rescue ActiveRecord::RecordInvalid # トランザクションによるエラーの分岐です。
    flash[:danger] = "ページ情報の取得に失敗しました、再アクセスしてください。"
    redirect_to root_url
  end
end
