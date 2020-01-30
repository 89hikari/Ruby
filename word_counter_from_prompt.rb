puts "> "
text = gets.chomp
words = text.split(" ")

frequencies = Hash.new(0)

words.each do |el|
  frequencies[el] += 1
end

frequencies = frequencies.sort_by do |el, count|
  count
end

frequencies.reverse!

frequencies.each do |key, value|
  puts "#{key} #{value}"
end