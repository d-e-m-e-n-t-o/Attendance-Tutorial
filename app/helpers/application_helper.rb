module ApplicationHelper
  
  # ページ毎にタイトルを返すメソッド
  def full_title(page_name = "")
    base_title = "AttendanceApp"
    if page_name.empty? # empty?メソッドは指定した値(page_name)が無い場合ifの処理を実行、ある場合はelseの処理を実行
      base_title
    else
      page_name + "|" + base_title
    end
  end
end
