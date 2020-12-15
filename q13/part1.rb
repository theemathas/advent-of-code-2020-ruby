lines = IO.readlines(File.join(__dir__, 'input.txt'), chomp: true)

start_at = Integer(lines[0])
intervals = lines[1].split(',').filter_map { |part| Integer(part) unless part == 'x' }

# Brute force > math
time = start_at
time += 1 while intervals.none? { |interval| time % interval == 0 }

target_bus = intervals.filter { |interval| time % interval == 0 }[0]

p target_bus * (time - start_at)
