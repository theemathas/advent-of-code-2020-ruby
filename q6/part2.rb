require 'set'

input = IO.read(File.join(__dir__, 'input.txt'))

list_of_num_common = input.split("\n\n").map do |group_string|
  group_string
    .split("\n")
    .map { |person_string| Set.new(person_string.chars) }
    .inject(&:intersection)
    .size
end

p list_of_num_common.sum
