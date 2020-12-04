lines = IO.readlines(File.join(__dir__, 'input.txt'), chomp: true)

raise 'Lines have different lengths' if lines.map(&:length).uniq.length != 1

def diag_with(lines, x_step, y_step)
  line_len = lines[0].length
  answer = 0
  lines.each_with_index do |s, i|
    answer += 1 if (i % y_step).zero? && (s[(i / y_step * x_step) % line_len] == '#')
  end
  answer
end

answers = [[1, 1], [3, 1], [5, 1], [7, 1], [1, 2]].map { |x| diag_with(lines, *x) }

p answers.reduce(:*)
