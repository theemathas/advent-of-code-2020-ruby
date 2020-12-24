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

flipped_tiles = Set.new
lines.map(&method(:str_to_vec)).each do |tile|
  fail unless tile.is_a? Vec
  if flipped_tiles.include?(tile)
    flipped_tiles.delete(tile)
  else
    flipped_tiles.add(tile)
  end
end

p flipped_tiles.size
