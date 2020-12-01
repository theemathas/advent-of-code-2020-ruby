# frozen_string_literal: true

numbers = IO.read('q1/input.txt').split.map { |x| Integer(x) }

numbers.each do |x|
  numbers.each do |y|
    print x, ' ', y, ' -> ', x * y, "\n" if x + y == 2020
  end
end
