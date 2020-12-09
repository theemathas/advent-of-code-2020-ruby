lines = IO.readlines(File.join(__dir__, 'input.txt'), chomp: true)
numbers = lines.map { |line| Integer(line, 10) }

def valid?(previous_numbers, current_number)
  fail unless previous_numbers.size == 25
  previous_numbers.combination(2).any? { |combi| combi.sum == current_number }
end

curr_index = 25
while valid?(numbers[(curr_index - 25)...curr_index], numbers[curr_index])
  curr_index += 1
  fail if curr_index >= numbers.size
end

p numbers[curr_index]
