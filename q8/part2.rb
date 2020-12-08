require 'set'

def run_commands(commands)
  visited = Set.new
  program_counter = 0
  accumulator = 0

  until visited.include?(program_counter)
    return accumulator if program_counter == commands.size # Terminated
    return nil if visited.include?(program_counter) # Infinite loop

    fail unless (0...commands.size).include?(program_counter) # Out of bounds
    visited.add(program_counter)

    match = /^(\w+) ([+-])(\d+)$/.match(commands[program_counter])
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
end

def edit_command(command)
  if command.include?('jmp')
    command.sub('jmp', 'nop')
  else
    command.sub('nop', 'jmp')
  end
end

lines = IO.readlines(File.join(__dir__, 'input.txt'), chomp: true)

answer = (0...lines.size).filter_map do |edit_position|
  temp = lines.clone
  temp[edit_position] = edit_command(temp[edit_position])
  run_commands(temp)
end

p answer
