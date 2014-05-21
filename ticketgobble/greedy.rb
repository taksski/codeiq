# -*- coding: utf-8 -*-
require './ticket.rb'

# 1月1日からの日数を算出する
# (問題のチケットには2/29開始のものがあったため、閏年として計算)
def days(m,d)
  [0, 31, 60, 91, 121, 152, 182, 213, 244, 274, 305, 335][m-1]+d
end  

# greedy algorithmによる解法
def greedy(tickets, debug=false)
  return [] if tickets == []
  first = tickets.sort{|t1,t2| t1.arrival <=> t2.arrival }[0]
  rest = tickets.find_all{|t| first < t }
  puts first.name if debug
  [first] + greedy(rest, debug)
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
  # 結果を表示
  max_tickets = greedy(tickets,debug)
  puts "#{max_tickets.length} #{max_tickets.map{|t| t.name}.sort.join(' ')}"
  puts "ENV: Ruby"
  puts "POINT: " 
end
