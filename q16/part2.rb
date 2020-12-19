require 'set'

input_string = IO.read(File.join(__dir__, 'input.txt'))

rules_string, my_ticket_string, nearby_tickets_string, *rest = input_string.split("\n\n")
fail unless rest.empty?

class Rule
  attr_reader :rule_name

  def initialize(string)
    match = /^([a-z ]+): (\d+)-(\d+) or (\d+)-(\d+)$/.match(string)
    fail unless match

    @rule_name = match[1]
    @a, @b, @c, @d = match[2..5].map { |s| Integer(s, 10) }
  end

  def valid?(num)
    (@a..@b).include?(num) or (@c..@d).include?(num)
  end
end

rules = rules_string.each_line(chomp: true).map { |line| Rule.new(line) }

def parse_ticket(string)
  string.split(',').map { |s| Integer(s, 10) }
end

nearby_tickets = nearby_tickets_string.each_line(chomp: true).drop(1).map { |line| parse_ticket(line) }
my_ticket = parse_ticket(my_ticket_string.lines[1])

valid_tickets = nearby_tickets.filter do |ticket|
  ticket.all? { |num| rules.any? { |rule| rule.valid?(num) } }
end
fail unless my_ticket.all? { |num| rules.any? { |rule| rule.valid?(num) } }
valid_tickets.push(my_ticket)

num_positions = valid_tickets.first.size
fail unless valid_tickets.all? { |ticket| ticket.size == num_positions }
fail unless num_positions == rules.size

# Construct a bipartite graph mapping position indices to rule indices
# validity_table[p] = Set of r such that rules[r] is valid for position p
validity_table = (0...num_positions).map do |position_index|
  Set.new((0...num_positions).filter do |rule_index|
    valid_tickets.all? { |ticket| rules[rule_index].valid?(ticket[position_index]) }
  end)
end

# Bipartite matching is a more sure-fire way, but it seems that
# for this input, we can just assign the rule to the only position
# where only it is valid and keep doing it until we're done.
rule_order = [nil] * num_positions
num_positions.times do
  next_position = validity_table.find_index do |valid_rules_indices|
    valid_rules_indices.size == 1
  end
  fail unless next_position
  next_rule_index = validity_table[next_position].first
  validity_table.each { |valid_rules_indices| valid_rules_indices.delete(next_rule_index) }
  fail unless rule_order[next_position].nil?
  rule_order[next_position] = next_rule_index
end

depature_numbers = my_ticket.zip(rule_order).filter_map do |temp|
  my_number, rule_index = temp
  my_number if rules[rule_index].rule_name.start_with?('departure')
end
p depature_numbers.inject(:*)
