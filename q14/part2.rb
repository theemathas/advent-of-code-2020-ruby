lines = IO.readlines(File.join(__dir__, 'input.txt'), chomp: true)

# Yields all the resultant addresses.
def mask_address(mask, address)
  num_floating = mask.count('X')
  (0...(1 << num_floating)).each do |floating_key|
    next_index_in_key = 0
    masked_address = address
    mask.reverse.each_char.each_with_index do |char, index|
      case char
      when '0'
        # Do nothing
      when '1'
        masked_address |= (1 << index)
      when 'X'
        masked_address &= ~(1 << index)
        masked_address |= (1 << index) if (floating_key & (1 << next_index_in_key)) != 0
        next_index_in_key += 1
      else fail
      end
    end
    fail unless next_index_in_key == num_floating
    yield masked_address
  end
end

memory = Hash.new(0)
mask = nil

lines.each do |line|
  if (match = /^mask = ([01X]{36})$/.match(line))
    mask = match[1]
  elsif (match = /^mem\[(\d+)\] = (\d+)$/.match(line))
    fail if mask.nil?
    address = Integer(match[1], 10)
    value = Integer(match[2], 10)
    mask_address(mask, address) do |masked_address|
      memory[masked_address] = value
    end
  else
    fail
  end
end

p memory.values.sum
