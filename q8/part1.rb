require 'set'

lines = IO.readlines(File.join(__dir__, 'input.txt'), chomp: true)

visited = Set.new
program_counter = 0
accumulator = 0

until visited.include?(program_counter)
  fail unless (0...lines.size).include?(program_counter)
  visited.add(program_counter)

  match = /^(\w+) ([+-])(\d+)$/.match(lines[program_counter])
  fail unless match

  argument =
    case match[2]
    when '+' then Integer(match[3], 10)
    when '-' then -Integer(match[3], 10)
    else fail
    end

  case match[1]
  when 'acc'
    accumulator += argument
    program_counter += 1
  when 'jmp'
    program_counter += argument
  when 'nop'
    program_counter += 1
  else fail
  end
end

p accumulator
