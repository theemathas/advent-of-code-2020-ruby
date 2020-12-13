state = IO.readlines(File.join(__dir__, 'input.txt'), chomp: true)

def in_bounds?(state, row, col)
  (0...(state.size)).include?(row) && (0...(state[0].size)).include?(col)
end

def count_occupied_around(state, row, col)
  [[0, 1], [1, 0], [0, -1], [-1, 0], [1, 1], [1, -1], [-1, 1], [-1, -1]].count do |direction_vector|
    around_row = row
    around_col = col
    loop do
      around_row += direction_vector[0]
      around_col += direction_vector[1]
      break unless in_bounds?(state, around_row, around_col) && (state[around_row][around_col] == '.')
    end

    in_bounds?(state, around_row, around_col) and state[around_row][around_col] == '#'
  end
end

def step(old_state)
  num_rows = old_state.size
  num_cols = old_state[0].length
  fail unless old_state.all? { |line| line.length == num_cols }

  new_state = Array.new(num_rows) { '?' * num_cols }

  (0...num_rows).each do |row|
    (0...num_cols).each do |col|
      new_state[row][col] =
        case old_state[row][col]
        when '.'
          '.'
        when 'L'
          # If a seat is empty, and no surrounding seat is occupied,
          # the seat becomes occupied
          if count_occupied_around(old_state, row, col).zero?
            '#'
          else
            'L'
          end
        when '#'
          # If a seat is occupied, and it's surrounded by at least 5 occupied seats,
          # the seat becomes empthy
          if count_occupied_around(old_state, row, col) >= 5
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
