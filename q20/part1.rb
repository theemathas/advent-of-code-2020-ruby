require 'set'

input = IO.read(File.join(__dir__, 'input.txt'))

$TILE_SIZE = 10  # Number of "pixels" in a tile's row/column
$ROW_LENGTH = Math.sqrt(input.scan(/\n\n/).count + 1).to_i # Number of tiles in a row/column

class Tile
  attr_reader :tile_id, :contents

  def self.from_string(string)
    lines = string.lines(chomp: true)

    match = /\ATile (\d+):\Z/.match(lines[0])
    tile_id = Integer(match[1], 10)

    new(tile_id, lines[1..])
  end

  def initialize(tile_id, contents)
    @tile_id = tile_id
    @contents = contents
    freeze
    fail unless @contents.size == $TILE_SIZE
    fail unless @contents.all? { |line| line.is_a?(String) && (line.size == $TILE_SIZE) }
  end

  # Rotate the tile counterclockwise
  def rotate
    new_contents = (0...$TILE_SIZE).map do |i|
      ((0...$TILE_SIZE).map do |j|
        @contents[j].chars[$TILE_SIZE - 1 - i]
      end).join
    end
    Tile.new(@tile_id, new_contents)
  end

  # Flip the tile top-bottom. (Top becomes Bottom and vice versa)
  def flip
    Tile.new(@tile_id, @contents.reverse)
  end

  def orient(orientation)
    case orientation
    when 0..3
      answer = self
      orientation.times { answer = answer.rotate }
    when 4..7
      answer = flip
      (orientation - 4).times { answer = answer.rotate }
    else fail
    end
    answer
  end
end

def connect_horizontal?(left_tile, left_orientation, right_tile, right_orientation)
  fail unless left_tile.is_a?(Tile)
  fail unless right_tile.is_a?(Tile)
  (left_tile.orient(left_orientation).contents.map { |line| line.chars.last }) ==
    (right_tile.orient(right_orientation).contents.map { |line| line.chars.first })
end

def connect_vertical?(upper_tile, upper_orientation, lower_tile, lower_orientation)
  fail unless upper_tile.is_a?(Tile)
  fail unless lower_tile.is_a?(Tile)
  upper_tile.orient(upper_orientation).contents.last == lower_tile.orient(lower_orientation).contents.first
end

tiles = input.split("\n\n").map(&Tile.method(:from_string))
fail unless tiles.size == $ROW_LENGTH**2

p 'Initializing combinations...'

all_combinations = (0...tiles.size).to_a.product((0..7).to_a, (0...tiles.size).to_a, (0..7).to_a)
$horizontal_combinations = Set.new(all_combinations.filter do |(tile1_index, orientation1, tile2_index, orientation2)|
  connect_horizontal?(tiles[tile1_index], orientation1, tiles[tile2_index], orientation2)
end)
$vertical_combinations = Set.new(all_combinations.filter do |(tile1_index, orientation1, tile2_index, orientation2)|
  connect_vertical?(tiles[tile1_index], orientation1, tiles[tile2_index], orientation2)
end)

p 'Done initializing combinations'

# tiles_so_far is left-to-right, row-by-row from top to bottom
def search(tiles_so_far, remaining_tiles)
  return tiles_so_far if remaining_tiles.empty?
  fail unless tiles_so_far.size + remaining_tiles.size == $ROW_LENGTH**2

  next_tile_index = tiles_so_far.size

  remaining_tiles.to_a.product((0..7).to_a).each do |(next_tile, orientation)|
    next_remaining_tiles = remaining_tiles.dup.delete(next_tile).freeze
    next_tiles_so_far = tiles_so_far.dup.push([next_tile, orientation]).freeze

    next if (next_tile_index % $ROW_LENGTH != 0) && !$horizontal_combinations.include?(
      [
        *next_tiles_so_far[next_tile_index - 1],
        *next_tiles_so_far[next_tile_index]
      ]
    )
    next if (next_tile_index >= $ROW_LENGTH) && !$vertical_combinations.include?(
      [
        *next_tiles_so_far[next_tile_index - $ROW_LENGTH],
        *next_tiles_so_far[next_tile_index]
      ]
    )

    search_result = search(next_tiles_so_far, next_remaining_tiles)
    return search_result if search_result
  end

  nil
end

search_result = search([].freeze, Set.new(0...tiles.size).freeze)
p search_result

answer = [0, $ROW_LENGTH - 1, $ROW_LENGTH**2 - 1, $ROW_LENGTH**2 - $ROW_LENGTH].map do |i|
  tiles[search_result[i][0]].tile_id
end.inject(:*)
p answer
