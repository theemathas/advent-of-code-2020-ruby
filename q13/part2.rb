#############################################################################
##
##  extended_gcd.rb
##
##  given non-negative integers a > b, compute
##  coefficients s, t such that gcd(a, b) == s*a + t*b
##
def extended_gcd(a, b)
  # trivial case first: gcd(a, 0) == 1*a + 0*0
  return 1, 0 if b == 0

  # recurse: a = q*b + r
  q, r = a.divmod b
  s, t = extended_gcd(b, r)

  # compute and return coefficients:
  # gcd(a, b) == gcd(b, r) == s*b + t*r == s*b + t*(a - q*b)
  [t, s - q * t]
end

# Above is from https://gist.github.com/gpfeiffer/4013925

lines = IO.readlines(File.join(__dir__, 'input.txt'), chomp: true)

start_at = Integer(lines[0])
intervals = lines[1].split(',').each_with_index.filter_map { |part, index| [Integer(part), index] unless part == 'x' }

# Returns x such that (x mod m1 = a1) and (x mod m2 = a2).
def chinese_remainder_theorem(a1, m1, a2, m2)
  fail unless (m1 > 0) && (m2 > 0) && (m1.gcd(m2) == 1)

  k1, k2 = extended_gcd(m1, m2)
  fail unless k1 * m1 + k2 * m2 == 1

  a1 * k2 * m2 + a2 * k1 * m1
end

curr_m = 1
curr_a = 0
intervals.each do |interval, index|
  curr_a = chinese_remainder_theorem(curr_a, curr_m, interval - index, interval)
  curr_m = curr_m.lcm(interval)
end
curr_a %= curr_m

curr_a += curr_m until curr_a >= start_at

p curr_a
