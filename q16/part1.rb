input_string = IO.read(File.join(__dir__, 'input.txt'))

rules_string, _my_ticket_string, nearby_tickets_string, *rest = input_string.split("\n\n")
fail unless rest.empty?

class Rule
  def initialize(string)
    match = /^[a-z ]+: (\d+)-(\d+) or (\d+)-(\d+)$/.match(string)
    fail unless match

    @a, @b, @c, @d = match[1..4].map { |s| Integer(s, 10) }
  end

  def valid?(num)
    (@a..@b).include?(num) or (@c..@d).include?(num)
  end
end

rules = rules_string.each_line(chomp: true).map { |line| Rule.new(line) }

nearby_tickets_lines = nearby_tickets_string.each_line(chomp: true).drop(1)
sum_errors = nearby_tickets_lines.sum do |line|
  numbers = line.split(',').map { |s| Integer(s, 10) }
  error_numbers = numbers.filter { |num| rules.none? { |rule| rule.valid?(num) } }
  error_numbers.sum
end
p sum_errors
