# Input
initial = [0, 5, 4, 1, 10, 14, 7]

history = initial[...-1]
next_number = initial[-1]

# last_index_of[x] is the last index of the history where the value is x
last_index_of = {}
history.each_with_index { |number, index| last_index_of[number] = index }

until history.size == 30_000_000
  number_after_next =
    if last_index_of.include?(next_number)
      history.size - last_index_of[next_number]
    else
      0
    end
  last_index_of[next_number] = history.size
  history.push(next_number)
  next_number = number_after_next
end

# p history[...30]
p history.last
