lines = IO.readlines(File.join(__dir__, 'input.txt'), chomp: true)
numbers = lines.map { |line| Integer(line, 10) }

# The Initial charging outlet
numbers.push(0)
# The final device's "built-in joltage adapter"
numbers.push(numbers.max + 3)

numbers.sort!
# numbers[1] - numbers[0], numbers[2] - numbers[1], ...
differences = numbers[...-1].zip(numbers[1...]).map { |pair| pair[1] - pair[0] }

p differences.count(3) * differences.count(1)
