lines = IO.readlines(File.join(__dir__, 'input.txt'), chomp: true)

memory = Hash.new(0)
mask = nil

lines.each do |line|
  if (match = /^mask = ([01X]{36})$/.match(line))
    mask = match[1]
  elsif (match = /^mem\[(\d+)\] = (\d+)$/.match(line))
    fail if mask.nil?
    address = Integer(match[1], 10)
    value = Integer(match[2], 10)
    mask.reverse.each_char.each_with_index do |char, index|
      case char
      when '0'
        value &= ~(1 << index)
      when '1'
        value |= (1 << index)
      when 'X'
        # Do nothing
      else fail
      end
    end
    memory[address] = value
  else
    fail
  end
end

p memory.values.sum
