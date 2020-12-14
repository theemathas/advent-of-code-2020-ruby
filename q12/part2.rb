lines = IO.readlines(File.join(__dir__, 'input.txt'), chomp: true)

ship_x = 0
ship_y = 0
waypoint_x = 10
waypoint_y = 1

lines.each do |line|
  command = line[0]
  number = Integer(line[1..], 10)

  case command
  when 'E'
    waypoint_x += number
  when 'N'
    waypoint_y += number
  when 'W'
    waypoint_x -= number
  when 'S'
    waypoint_y -= number
  when 'L'
    (number / 90).times { waypoint_x, waypoint_y = -waypoint_y, waypoint_x }
  when 'R'
    (number / 90).times { waypoint_x, waypoint_y = waypoint_y, -waypoint_x }
  when 'F'
    ship_x += waypoint_x * number
    ship_y += waypoint_y * number
  else
    fail
  end
end

p ship_x.abs + ship_y.abs
