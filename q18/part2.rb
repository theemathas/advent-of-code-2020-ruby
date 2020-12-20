lines = IO.readlines(File.join(__dir__, 'input.txt'), chomp: true)

def eval_formula(formula)
  formula = formula.gsub(' ', '')
  fail if /\d\d/.match(formula) # Does not support 2-digit numbers

  postfix_notation = []

  # Shunting-yard algorithm to convert infix to postfix
  operator_stack = []
  formula.each_char do |char|
    case char
    when /\d/
      postfix_notation.push(Integer(char, 10))
    when '*'
      postfix_notation.push(operator_stack.pop) while ['+', '*'].include?(operator_stack.last)
      operator_stack.push(char)
    when '+'
      postfix_notation.push(operator_stack.pop) while operator_stack.last == '+'
      operator_stack.push(char)
    when '('
      operator_stack.push('(')
    when ')'
      postfix_notation.push(operator_stack.pop) while !operator_stack.empty? && (operator_stack.last != '(')
      fail if operator_stack.empty?
      fail unless operator_stack.last == '('
      operator_stack.pop
    else
      fail
    end
  end
  postfix_notation.push(operator_stack.pop) until operator_stack.empty?

  # Evaluate the postfix notation
  operand_stack = []
  postfix_notation.each do |item|
    if item.is_a?(Integer)
      operand_stack.push(item)
    else
      num2 = operand_stack.pop
      num1 = operand_stack.pop
      result =
        case item
        when '+' then num1 + num2
        when '*' then num1 * num2
        else fail
        end
      operand_stack.push(result)
    end
  end
  fail unless operand_stack.size == 1
  operand_stack.pop  # The only remaining value is the result
end

p lines.map(&method(:eval_formula)).sum
