def count(a,n)
  return 0 if a.size < 2
  count = 0
  low = []
  high = []
  a.each { |i|
    if (i > n)
      high.push i
    else
      low.push i
      count += high.size
    end
  }
  count + count(low, n-(low.size/2)) + count(high, n+(high.size/2))
end

cnt = 0
begin_time = Time.now
open("crossing.txt", "r") do |file|
  a = file.map { |line| line.chop.to_i }
  cnt = count(a, a.size / 2)
end
end_time = Time.now
puts "#{cnt},#{(end_time-begin_time).to_i}"
