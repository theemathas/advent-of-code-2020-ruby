# The printed search_result from part 1, which uses 14 minutes to run.
part1_search_result = [
  [49, 0], [39, 7], [53, 7], [29, 6], [88, 3], [103, 3], [31, 2], [52, 2], [91, 4], [83, 6], [120, 7], [68, 1],
  [72, 6], [60, 4], [51, 2], [5, 6], [101, 0], [111, 3], [14, 4], [125, 7], [20, 0], [8, 1], [141, 1], [36, 3],
  [71, 1], [28, 3], [131, 3], [27, 2], [43, 7], [99, 6], [128, 1], [48, 6], [112, 4], [100, 4], [127, 6], [40, 1],
  [66, 2], [35, 2], [97, 4], [64, 2], [79, 4], [54, 3], [133, 3], [93, 3], [73, 2], [137, 0], [23, 6], [77, 0],
  [109, 1], [25, 4], [24, 0], [80, 7], [74, 6], [56, 3], [62, 4], [58, 1], [113, 4], [132, 4], [34, 7], [12, 7],
  [0, 1], [115, 1], [63, 7], [92, 4], [2, 4], [1, 1], [13, 2], [138, 7], [84, 2], [94, 6], [96, 0], [41, 4],
  [136, 7], [124, 1], [70, 3], [26, 7], [129, 7], [44, 7], [106, 6], [108, 4], [130, 4], [85, 4], [98, 1], [69, 7],
  [22, 6], [4, 1], [102, 7], [7, 0], [61, 2], [118, 4], [45, 2], [57, 6], [17, 2], [30, 2], [55, 7], [105, 6],
  [46, 3], [78, 4], [42, 0], [140, 6], [3, 0], [67, 6], [122, 4], [121, 4], [135, 7], [65, 4], [6, 7], [89, 0],
  [134, 7], [107, 3], [123, 1], [82, 3], [15, 6], [47, 1], [19, 4], [16, 0], [139, 2], [9, 6], [37, 6], [21, 4],
  [143, 1], [11, 6], [59, 3], [117, 2], [10, 0], [95, 2], [126, 1], [90, 7], [32, 4], [104, 7], [114, 3], [119, 4],
  [116, 4], [18, 2], [75, 4], [33, 0], [50, 4], [110, 6], [87, 3], [81, 7], [38, 2], [142, 3], [76, 2], [86, 1]
]

input = IO.read(File.join(__dir__, 'input.txt'))

$TILE_SIZE = 10 # Number of "pixels" in a tile's row/column
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

tiles = input.split("\n\n").map(&Tile.method(:from_string))
fail unless tiles.size == $ROW_LENGTH**2

arranged_tiles = part1_search_result.map do |(tile_index, orientation)|
  contents = tiles[tile_index].orient(orientation).contents
  contents[1...-1].map { |line| line.chars[1...-1].join }
end

picture = arranged_tiles.each_slice($ROW_LENGTH).flat_map do |tile_row|
  tile_row.transpose.map(&:join)
end
$PICTURE_SIZE = picture.size
fail unless picture.all? { |row| row.is_a?(String) && (row.size == $PICTURE_SIZE) }

# To flip, just do picture.reverse
def rotate_picture(picture)
  (0...$PICTURE_SIZE).map do |i|
    ((0...$PICTURE_SIZE).map do |j|
      picture[j].chars[$PICTURE_SIZE - 1 - i]
    end).join
  end
end

# I tried flipping and rotating until there's at least one monster found.
picture = picture.reverse
picture = rotate_picture(picture)

monster_pattern = [
  '                  # ',
  '#    ##    ##    ###',
  ' #  #  #  #  #  #   '
]
monster_coords = monster_pattern.each_with_index.flat_map do |string, x|
  string.chars.each_with_index.filter_map do |char, y|
    [x, y] if char == '#'
  end
end

monsters = (0...$PICTURE_SIZE).to_a.product((0...$PICTURE_SIZE).to_a).filter do |(x, y)|
  monster_coords.all? { |(dx, dy)| !picture[x + dx].nil? and picture[x + dx].chars[y + dy] == '#' }
end
p monsters

monsters.each do |(x, y)|
  monster_coords.each { |(dx, dy)| picture[x + dx][y + dy] = 'O' }
end
puts picture
p picture.join.count('#')
