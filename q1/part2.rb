# frozen_string_literal: true

numbers = IO.read('q1/input.txt').split.map { |x| Integer(x) }

numbers.each do |x|
  numbers.each do |y|
    numbers.each do |z|
      print x, ' ', y, ' ', z, ' -> ', x * y * z, "\n" if x + y + z == 2020
    end
  end
end
