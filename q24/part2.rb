require 'set'

lines = IO.readlines(File.join(__dir__, 'input.txt'), chomp: true)

# Coordinate system axes:
# +X is east, -X is west
# +Y is northeast, -Y is southwest

Vec = Struct.new(:x, :y) do
  def +(other)
    Vec.new(x + other.x, y + other.y)
  end
end

def str_to_vec(string)
  seq = string.chars.reverse
  current = Vec.new(0, 0)
  until seq.empty?
    direction =
      case seq.pop
      when 'e'
        Vec.new(1, 0) # East
      when 'w'
        Vec.new(-1, 0) # West
      when 'n'
        case seq.pop
        when 'e'
          Vec.new(0, 1) # Northeast
        when 'w'
          Vec.new(-1, 1) # Northwest
        end
      when 's'
        case seq.pop
        when 'e'
          Vec.new(1, -1) # Southeast
        when 'w'
          Vec.new(0, -1) # Southwest
        end
      end
    current += direction
  end
  current
end

black_tiles = Set.new
lines.map(&method(:str_to_vec)).each do |tile|
  fail unless tile.is_a? Vec
  if black_tiles.include?(tile)
    black_tiles.delete(tile)
  else
    black_tiles.add(tile)
  end
end

ALL_DIRECTIONS = %w[e w ne nw se sw].map(&method(:str_to_vec)).freeze

100.times do
  # This part is modified from q17
  # adjacent_counter[vec] = number of tiles adjacent to vec that are in black_tiles
  adjacent_counter = Hash.new(0)
  black_tiles.each do |tile|
    ALL_DIRECTIONS.each do |direction|
      adjacent_counter[tile + direction] += 1
    end
  end

  black_to_white = black_tiles - Set.new(adjacent_counter.filter do |_tile, num_adjacent|
    [1, 2].include?(num_adjacent)
  end.keys)

  white_to_black = Set.new(adjacent_counter.filter do |_tile, num_adjacent|
    num_adjacent == 2
  end.keys) - black_tiles

  black_tiles = (black_tiles - black_to_white) | white_to_black
end

p black_tiles.size
