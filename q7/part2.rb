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

# Counts how many bags are in a certain color of bags,
# _including_ the outer bag itself.
def count_bags(bag_rules_hash, color)
  raise "'#{color}' is invalid" unless bag_rules_hash.include?(color)

  answer = 1
  bag_rules_hash[color].each do |bag_and_num|
    answer += bag_and_num.num * count_bags(bag_rules_hash, bag_and_num.color)
  end
  answer
end

# There are more performant ways but whatever
# Subtract 1 to exclude the outer bag
p count_bags(bag_rules_hash, 'shiny gold') - 1
