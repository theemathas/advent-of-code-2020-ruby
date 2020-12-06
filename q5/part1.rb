lines = IO.readlines(File.join(__dir__, 'input.txt'), chomp: true)

def to_id(boarding_pass)
  raise 'Invalid pass length' unless boarding_pass.size == 10

  row = string_to_num(boarding_pass[...7], 'F', 'B')
  col = string_to_num(boarding_pass[7...], 'L', 'R')
  row * 8 + col
end

# Interpret the string as a binary number, with 1s and 0s being represented by
# one_char and zero_char, respectively. Returns the number as an Integer.
def string_to_num(string, zero_char, one_char)
  raise 'Invalid 0/1 characters' unless (one_char.size == 1) && (zero_char.size == 1)
  raise '0/1 characters are equal' unless one_char != zero_char

  Integer(string.tr(zero_char + one_char, '01'), 2)
end

seat_ids = lines.map { |boarding_pass| to_id(boarding_pass) }
p seat_ids.max
