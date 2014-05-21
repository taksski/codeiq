# -*- coding: utf-8 -*-
class Ticket
  attr :name
  attr :departure
  attr :arrival
  attr :max_tickets

  def initialize(name, departure, arrival)
    @name = name
    @departure = departure
    @arrival = arrival
    @max_tickets = nil
  end

  def max(tickets)
    if @max_tickets
      # すでに探索を行っている場合はその結果を返す
      @max_tickets
    else
      result = []
      # 自分の到着日より出発日が後のチケットが対象
      candidates = tickets.find_all { |t| self < t }
      candidates.each { |t|
        r = t.max(tickets)
        result = r if result.length < r.length
      }
      @max_tickets = [self] + result
    end
  end

  # 到着日が別のチケットの出発日より前かどうかで順序を決定する
  def <(other)
    @arrival < other.departure
  end

end
