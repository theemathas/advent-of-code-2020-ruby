state = IO.readlines(File.join(__dir__, 'input.txt'), chomp: true)

def cells_around(state, row, col)
  [[0, 1], [1, 0], [0, -1], [-1, 0], [1, 1], [1, -1], [-1, 1], [-1, -1]].filter_map do |direction_vector|
    around_row = row + direction_vector[0]
    around_col = col + direction_vector[1]

    if (0...(state.size)).include?(around_row) && (0...(state[0].size)).include?(around_col)
      state[around_row][around_col]
    end
  end
end

def step(old_state)
  num_rows = old_state.size
  num_cols = old_state[0].length
  fail unless old_state.all? { |line| line.length == num_cols }

  new_state = Array.new(num_rows) { '?' * num_cols }

  (0...num_rows).each do |row|
    (0...num_cols).each do |col|
      around = cells_around(old_state, row, col)
      new_state[row][col] =
        case old_state[row][col]
        when '.'
          '.'
        when 'L'
          # If a seat is empty, and no surrounding seat is occupied,
          # the seat becomes occupied
          if around.none? { |cell| cell == '#' }
            '#'
          else
            'L'
          end
        when '#'
          # If a seat is occupied, and it's surrounded by at least 4 occupied seats,
          # the seat becomes empthy
          if around.count('#') >= 4
            'L'
          else
            '#'
          end
        else
          raise 'Unrecognized element'
        end
    end
  end

  new_state
end

loop do
  old_state = state
  state = step(old_state)
  break if old_state == state
end

puts state.join.count('#')
