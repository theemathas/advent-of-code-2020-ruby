lines = IO.read('q2/input.txt').lines

num_valid = 0

lines.each do |line|
  match = /^(\d+)-(\d+) ([a-z]): ([a-z]+)$/.match(line)
  raise "Invalid line: '#{line}''" unless match

  idx1 = Integer(match[1], 10) - 1
  idx2 = Integer(match[2], 10) - 1
  char_to_check = match[3]
  password = match[4]

  raise 'invalid indexes' unless idx1 >= 0 && idx1 < idx2 && idx2 < password.length

  num_valid += 1 if (password[idx1] == char_to_check) ^ (password[idx2] == char_to_check)
end

puts num_valid
