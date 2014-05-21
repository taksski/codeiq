# -*- coding: utf-8 -*-
require './ticket.rb'

# 1月1日からの日数を算出する
# (問題のチケットには2/29開始のものがあったため、閏年として計算)
def days(m,d)
  [0, 31, 60, 91, 121, 152, 182, 213, 244, 274, 305, 335][m-1]+d
end  

# trueとすると、経過を表示する
debug = false

open(ARGV[0]) do |file|
  # チケットをファイルから読み込む
  tickets = []
  file.each_line { |s|
    /([A-Za-z]+) (\d+)\/(\d+)-(\d+)\/(\d+)/ =~ s
    d = days($2.to_i, $3.to_i)
    a = days($4.to_i, $5.to_i)
    tickets.push Ticket.new($1, d, a)
  }
  # 各チケットごとに、最多チケットの組を求める
  tickets.each { |t| 
    t.max(tickets)
    if debug
      m = t.max_tickets.map{|t1| "#{t1.name}(#{t1.departure},#{t1.arrival})"}
      puts "#{t.name} #{t.max_tickets.length} #{m.join(',')} "
    end
  }
  # 結果を表示
  max_tickets = tickets.
    sort{|t1,t2|t2.max_tickets.length <=> t1.max_tickets.length}[0].max_tickets
  puts "#{max_tickets.length} #{max_tickets.map{|t| t.name}.sort.join(' ')}"
  puts "ENV: Ruby"
  puts "POINT: " 
end
