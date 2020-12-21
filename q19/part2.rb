require 'set'

input = IO.read(File.join(__dir__, 'input.txt'))
grammar_input, strings_input = input.split("\n\n")

def set_hash
  Hash.new { |hash, key| hash[key] = [] }
end

# `x: y z` turns into `split_rules[[y, z]] = {x, ...}`
split_rules = set_hash
# `x: y` turns into `single_rules[y] = {x, ...}`
single_rules = set_hash
# `x: "a"` turns into `char_rules["a"] = {x, ...}`
char_rules = set_hash

grammar_input.lines(chomp: true) do |line|
  match = /^(\d+): (.*)$/.match(line)
  resultant_symbol = Integer(match[1])

  match[2].split(/ \| /).each do |grammar_part|
    if (match = /^(\d+)$/.match(grammar_part))
      single_rules[Integer(match[1])].push(resultant_symbol)
    elsif (match = /^(\d+) (\d+)$/.match(grammar_part))
      split_rules[[Integer(match[1]), Integer(match[2])]].push(resultant_symbol)
    elsif (match = /^"([a-z])"$/.match(grammar_part))
      char_rules[match[1]].push(resultant_symbol)
    else
      fail
    end
  end
end

# Part 2 adds the following 2 rules:
# 8: 42 8
# 11: 42 11 31
# The 2nd rule is simulated as "11: 42 -1" and "-1: 11 31"
split_rules[[42, 8]].push(8)
split_rules[[42, -1]].push(11)
split_rules[[11, 31]].push(-1)

def valid?(string, split_rules, single_rules, char_rules)
  p string

  # table[[from, to]] contains the symbols that can expand to string[from...to]
  table = set_hash

  (0...string.length).each do |i|
    symbols = char_rules[string[i]].dup

    loop do
      new_symbols = symbols | symbols.flat_map(&single_rules).compact
      break if new_symbols == symbols
      symbols = new_symbols
    end
    table[[i, i + 1]] = symbols
  end

  (0...string.length).to_a.reverse.each do |from|
    (from + 2..string.length).each do |to|
      symbols = Set.new
      (from + 1...to).each do |mid|
        left_symbols = table[[from, mid]]
        right_symbols = table[[mid, to]]
        left_symbols.each do |left|
          right_symbols.each do |right|
            symbols |= split_rules[[left, right]]
          end
        end
      end

      loop do
        new_symbols = symbols | symbols.flat_map(&single_rules).compact
        break if new_symbols == symbols
        symbols = new_symbols
      end
      table[[from, to]] = symbols
    end
  end

  table[[0, string.length]].include?(0)
end

p(strings_input.lines(chomp: true).count do |line|
  valid?(line, split_rules, single_rules, char_rules)
end)
