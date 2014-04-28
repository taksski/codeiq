require 'net/http'
require 'uri'

def api_encode(str)
  request = URI::HTTP.build([nil, "spacetalky.textfile.org", nil, "/api.cgi", "input=" + str, nil])
  Net::HTTP.get(request)
end

open('answer1.txt') { |file|
  file.each { |line|
    puts line
    elem = line.chop.split(':')
    next if (elem[0].nil? ||
             elem[0] == 'X' ||
             elem[0] == 'Env' ||
             elem[0] == 'POINT')
    encoded_word = api_encode(elem[0])
    puts "result:#{encoded_word} desire:#{elem[1]}"
    if (encoded_word != elem[1])
      puts "FAIL"
      exit(1)
    end
  }
}

puts "SUCCESS"
