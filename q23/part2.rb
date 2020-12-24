input = '167248359'

initial_cups = input.chars.map { |c| Integer(c) }
initial_cups += ((initial_cups.size + 1)..1_000_000).to_a
$num_cups = initial_cups.size
fail unless $num_cups == 1_000_000

def decrement(x)
  x == 1 ? $num_cups : x - 1
end

cup_after = Array.new($num_cups + 1)
(0..$num_cups - 1).each do |i|
  cup_after[initial_cups[i]] = initial_cups[i + 1]
end
cup_after[initial_cups.last] = initial_cups.first

curr_cup = initial_cups.first

10_000_000.times do
  # Remove 3 cups
  removed_cups = [cup_after[curr_cup]]
  2.times { removed_cups.push(cup_after[removed_cups.last]) }
  cup_after[curr_cup] = cup_after[removed_cups.last]

  # Find the destination
  destination = decrement(curr_cup)
  destination = decrement(destination) while removed_cups.include?(destination)

  # Reinsert the 3 cups after the destination
  cup_after[removed_cups.last] = cup_after[destination]
  cup_after[destination] = removed_cups.first

  curr_cup = cup_after[curr_cup]
end

p cup_after[1] * cup_after[cup_after[1]]
