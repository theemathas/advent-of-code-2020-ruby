lines = IO.readlines(File.join(__dir__, 'input.txt'), chomp: true)

#     E, N, W, S
dx = [1, 0, -1, 0]
dy = [0, 1, 0, -1]

direction = 0
x = 0
y = 0

lines.each do |line|
  command = line[0]
  number = Integer(line[1..], 10)

  case command
  when 'E'
    x += number
  when 'N'
    y += number
  when 'W'
    x -= number
  when 'S'
    y -= number
  when 'L'
    direction = (direction + number / 90) % 4
  when 'R'
    direction = (direction + 3 * number / 90) % 4
  when 'F'
    x += dx[direction] * number
    y += dy[direction] * number
  else
    fail
  end
end

p x.abs + y.abs
