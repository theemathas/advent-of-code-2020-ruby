require 'set'

input = IO.read(File.join(__dir__, 'input.txt'))

group_sizes = input.split("\n\n").map do |group_string|
  Set.new(group_string.gsub(/\s/, '').chars).size
end

p group_sizes.sum
