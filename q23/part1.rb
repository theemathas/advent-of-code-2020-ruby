input = '167248359'

cups = input.chars.map { |c| Integer(c) }
$num_cups = cups.size

def decrement(x)
  x == 1 ? $num_cups : x - 1
end

100.times do
  curr_cup = cups.shift
  removed_cups = cups.shift(3)

  destination = decrement(curr_cup)
  destination = decrement(destination) while removed_cups.include?(destination)
  destination_index = cups.index(destination)

  cups.insert(destination_index + 1, *removed_cups)
  cups.push(curr_cup)
end

cups.push(cups.shift) while cups.first != 1
cups.shift
p cups.map(&:to_s).join
