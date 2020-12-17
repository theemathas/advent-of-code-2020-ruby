# Input
history = [0, 5, 4, 1, 10, 14, 7]

until history.size == 2020
  number_to_find = history.last
  found_index = history.reverse_each.drop(1).find_index(number_to_find)
  if found_index
    history.push(found_index + 1)
  else
    history.push(0)
  end
end

p history.last
