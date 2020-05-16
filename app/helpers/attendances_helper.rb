module AttendancesHelper
  
  # 出勤、退勤、ボタン表示条件をメソッド化
  # (繰り返し処理されているAttendanceオブジェクトを引数に指定している)
  def attendance_state(attendance)
    if Date.current == attendance.worked_on
    # Date.current(当日の日付)と受け取ったAttendanceオブジェクトの日付が一致するか検証
      return '出勤' if attendance.started_at.nil?
      return '退勤' if attendance.started_at.present? && attendance.finished_at.nil?
    end
    false
  end
  
  # 出勤時間と退勤時間を受け取り、在社時間を計算して返します。
  def working_times(start, finish)
    format("%.2f", (((finish - start) / 60) / 60.0))
  end
end