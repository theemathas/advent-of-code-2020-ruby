lines = IO.readlines(File.join(__dir__, 'input.txt'), chomp: true)

BagAndNum = Struct.new(:color, :num)
# BagRule#inside_bags is an array containing BagAndNum objects.
BagRule = Struct.new(:outside_color, :inside_bags)

# Parse a line of a bag rule into a BagRule object.
def parse_rule(string)
  match = /^(.*) contain (.*)\.$/.match(string)
  fail unless match

  outside_color = parse_bag_color(match[1])
  inside_bags = if match[2] == 'no other bags'
                  []
                else
                  match[2].split(', ').map do |bag_and_num_string|
                    inner_match = /^(\d+) (.*)$/.match(bag_and_num_string)
                    BagAndNum.new(parse_bag_color(inner_match[2]), Integer(inner_match[1]))
                  end
                end

  BagRule.new(outside_color, inside_bags)
end

def parse_bag_color(string)
  match = /^(\w+ \w+) bags?$/.match(string)
  fail unless match
  match[1]
end

bag_rules_array = lines.map { |string| parse_rule(string) }
bag_rules_hash = Hash[bag_rules_array.map { |bag_rule| [bag_rule.outside_color, bag_rule.inside_bags] }]

def reachable?(bag_rules_hash, from, to)
  return true if from == to
  raise "'#{from}' is invalid" unless bag_rules_hash.include?(from)

  bag_rules_hash[from].each do |bag_and_num|
    return true if reachable?(bag_rules_hash, bag_and_num.color, to)
  end
  false
end

target_color = 'shiny gold'

# There are more performant ways but whatever
answer = bag_rules_hash.each_key.map do |color|
  color != target_color and reachable?(bag_rules_hash, color, target_color)
end.count(true)
p answer
