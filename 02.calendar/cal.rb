# 必要なライブラリをインポート
require "date"
require "optparse"

# コマンドライン引数を指定
arguments = ARGV.getopts("", "y:#{Date.today.year}", "m:#{Date.today.month}") # 必須の第1引数に適当な値("")をデフォルト値として入力
year = arguments["y"]
month = arguments["m"]

# カレンダー上部に年月を表示
print("      ", month, "月", " ", year, "\n")

# 日曜日〜土曜日までを表示
print("日 ","月 ","火 ","水 ","木 ","金 ","土 ", "\n")

# 月の最初,最後の日を整数型で算出
first_day = Date.new(year.to_i, month.to_i, 1)
last_day = Date.new(year.to_i, month.to_i, -1)

# 始まる曜日に合わせて空欄を挿入
space = "   " * first_day.wday # wday　日曜日:0..土曜日:6
print space

# カレンダーの形になるよう最初日〜最終日を処理
month_day_range = first_day.day .. last_day.day # 1ヵ月の日数をカウント
wd_count = first_day.wday # 1日の曜日を数値で表示
month_day_range.each do |day|
  print day.to_s.rjust(2) # 右端で折り返し、(n)は余白
  print " "
    wd_count = wd_count + 1
    if (wd_count % 7 == 0) # 土曜日で改行
        print("\n")
    end
  end