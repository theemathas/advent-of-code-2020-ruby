require 'set'

input = IO.read(File.join(__dir__, 'input.txt'))
player_1_input, player_2_input = input.split("\n\n")

deck1 = player_1_input.lines(chomp: true).drop(1).map { |line| Integer(line) }
deck2 = player_2_input.lines(chomp: true).drop(1).map { |line| Integer(line) }

# Return true iff player 1 wins
def play(deck1, deck2)
  played_positions = Set.new
  until deck1.empty? || deck2.empty?
    if played_positions.include?([deck1, deck2])
      $last_deck = deck1
      return true
    end
    played_positions.add([deck1.dup, deck2.dup])

    card1 = deck1.shift
    card2 = deck2.shift

    player_1_win =
      if (deck1.size >= card1) && (deck2.size >= card2)
        play(deck1[...card1], deck2[...card2])
      else
        (card1 > card2)
      end
    if player_1_win
      deck1 += [card1, card2]
    else
      deck2 += [card2, card1]
    end
  end

  if deck2.empty?
    $last_deck = deck1
    true
  else
    $last_deck = deck2
    false
  end
end

play(deck1, deck2)
score = $last_deck.reverse.each_with_index.map { |num, i| num * (i + 1) }.sum
p score
