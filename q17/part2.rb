require 'set'

ALL_DIRECTIONS = [-1, 0, 1].product([-1, 0, 1], [-1, 0, 1], [-1, 0, 1])
ALL_DIRECTIONS.delete([0, 0, 0, 0])
ALL_DIRECTIONS.freeze

def add_vector(x, y)
  x.zip(y).map(&:sum)
end

lines = IO.readlines(File.join(__dir__, 'input.txt'), chomp: true)

active_cells = Set.new
lines.each_with_index do |line, x|
  line.chars.each_with_index do |char, y|
    active_cells.add([x, y, 0, 0]) if char == '#'
  end
end

def step_state(old_active_cells)
  # adjacent_counter[coord] = number of cells adjacent to coord that are in old_active_cells
  adjacent_counter = Hash.new(0)
  old_active_cells.each do |cell|
    ALL_DIRECTIONS.each do |direction|
      adjacent_counter[add_vector(cell, direction)] += 1
    end
  end

  new_active_cells = Set.new
  adjacent_counter.each do |cell, count|
    new_active_cells.add(cell) if (count == 3) || ((count == 2) && old_active_cells.include?(cell))
  end
  new_active_cells
end

6.times { active_cells = step_state(active_cells) }
p active_cells.size
