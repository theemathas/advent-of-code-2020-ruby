input = IO.read(File.join(__dir__, 'input.txt'))
player_1_input, player_2_input = input.split("\n\n")

deck1 = player_1_input.lines(chomp: true).drop(1).map { |line| Integer(line) }
deck2 = player_2_input.lines(chomp: true).drop(1).map { |line| Integer(line) }

until deck1.empty? || deck2.empty?
  card1 = deck1.shift
  card2 = deck2.shift
  if card1 > card2
    deck1 += [card1, card2]
  else
    deck2 += [card2, card1]
  end
end

deck = deck1.empty? ? deck2 : deck1
score = deck.reverse.each_with_index.map { |num, i| num * (i + 1) }.sum

p score
