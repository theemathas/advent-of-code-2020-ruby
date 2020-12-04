lines = IO.readlines(File.join(__dir__, 'input.txt'), chomp: true)

raise 'Lines have different lengths' if lines.map(&:length).uniq.length != 1

line_len = lines[0].length
answer = 0
lines.each_with_index do |s, i|
  answer += 1 if s[(i * 3) % line_len] == '#'
end
puts answer
