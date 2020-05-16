class Attendance < ApplicationRecord
  # ターミナルで実行したrails g model Attendance worked_on:date started_at:datetime 
  # finished_at:datetime note:string user:referencesのコマンドにはuser:referenceという
  # 引数が含まれている。これがbelongs_to :userを生成してくれる。これにより、自動的に
  # user_id属性(カラム)が追加され、ActiveRecordがUserモデルとAttendanceモデルを紐づける
  # 準備をしてくれる。
  belongs_to :user
  # AttendanceモデルがUserモデルに対して、1耐1の関連性を示すコード。
  
  validates :worked_on, presence: true
  validates :note, length: {maximum: 50}
  
  validate :finished_at_is_invalid_without_a_started_at
  # これもバリデーションの書き方の1つで、条件が1つのカラムで収まらない為、validate(この場合末尾に
  # sは不要)にメソッド↓を渡して登録している。(started_atが不在の状態でfinished_atが存在しては
  # ならないを実現)
  
  def finished_at_is_invalid_without_a_started_at
    errors.add(:started_at, "が必要です")if started_at.blank? && finished_at.present?
    # blank?は対象がnilでtrueを返す。present?はその逆(値が存在する場合)でtrueを返す。
    # errors.add(:started_at, "が必要です")でエラーメッセージを追加する。
  end
end
