lines = IO.readlines(File.join(__dir__, 'input.txt'), chomp: true)
numbers = lines.map { |line| Integer(line, 10) }

# The Initial charging outlet
numbers.push(0)
# The final device's "built-in joltage adapter"
numbers.push(numbers.max + 3)

numbers.sort!

# ways_to[i] is the number of to arrange the adapters
# so the end of the chain is numbers[i]
ways_to = Array.new(numbers.size)
ways_to[0] = 1
(1...numbers.size).each do |curr_index|
  ways_to[curr_index] = 0
  prev_index = curr_index - 1
  while (prev_index >= 0) && (numbers[curr_index] - numbers[prev_index] <= 3)
    ways_to[curr_index] += ways_to[prev_index]
    prev_index -= 1
  end
end

p ways_to.last
