lines = IO.readlines(File.join(__dir__, 'input.txt'), chomp: true)
numbers = lines.map { |line| Integer(line, 10) }

# Answer to part 1
target_sum = 776_203_571

# Find a solution that is a prefix of the numbers argument
# Returns nil if not found.
def find_prefix_solution(numbers, target_sum)
  return nil if numbers.size < 2

  sum_so_far = numbers[0]
  numbers[1..].each do |x|
    sum_so_far += x
    return x + numbers[0] if sum_so_far == target_sum
  end

  nil
end

answer = (0...(numbers.size)).flat_map do |index_from|
  ((index_from + 1)...(numbers.size)).flat_map do |index_to|
    sublist = numbers[index_from..index_to]
    sublist.min + sublist.max if sublist.sum == target_sum
  end
end.compact

p answer
