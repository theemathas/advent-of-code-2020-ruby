require 'prime'

lines = IO.readlines(File.join(__dir__, 'input.txt'), chomp: true)
fail unless lines.size == 2

public1 = Integer(lines[0], 10)
public2 = Integer(lines[1], 10)
base = 7
mod = 20_201_227
fail unless mod.prime?
fail unless (0...mod).include?(public1)
fail unless (0...mod).include?(public2)

# We know that:
# public1 = (base ** private1) % mod
# public2 = (base ** private2) % mod
# We need to find the value of: (base ** (private1 * private2)) % mod

private1 = 0
private1 += 1 until base.pow(private1, mod) == public1

p public2.pow(private1, mod)
