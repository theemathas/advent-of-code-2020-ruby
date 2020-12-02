lines = IO.read('q2/input.txt').lines

num_valid = 0

lines.each do |line|
  match = /^(\d+)-(\d+) ([a-z]): ([a-z]+)$/.match(line)
  raise "Invalid line: '#{line}''" unless match

  lo_num = Integer(match[1], 10)
  hi_num = Integer(match[2], 10)
  char_to_count = match[3]
  password = match[4]

  num_char = password.count(char_to_count)
  num_valid += 1 if lo_num <= num_char && num_char <= hi_num
end

puts num_valid
