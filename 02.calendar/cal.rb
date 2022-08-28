# 必要なライブラリをインポート
require "date"
require "optparse"

# オプション引数を指定
params = ARGV.getopts('y:m:')
year = params["y"]
month = params["m"]

# カレンダー上部に年月を表示
print("      ", month, "月", " ", year, "\n")

# 日曜日〜土曜日までを表示
print("日 ","月 ","火 ","水 ","木 ","金 ","土 ", "\n")

# 月の最初と最後の日を整数型で算出
first_day = Date.new(year.to_i, month.to_i, 1)
last_day = Date.new(year.to_i, month.to_i, -1)

# 始まる曜日に合わせて空欄を挿入
space = "   " * first_day.wday
print space

month_day_range = first_day.day .. last_day.day # 1ヶ月の日数
wd_count = first_day.wday # 1日の曜日（数値表示）
month_day_range.each do |day|
  print day.to_s.rjust(2) # 右端で折り返し
  print " "
    wd_count = wd_count + 1 # 土曜日で改行。曜日=数値なのがポイント。
    if (wd_count % 7 == 0)
        print("\n")
    end
  end