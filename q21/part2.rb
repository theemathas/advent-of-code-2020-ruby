require 'set'

lines = IO.readlines(File.join(__dir__, 'input.txt'), chomp: true)

Food = Struct.new(:ingredients, :allergens)

foods = lines.map do |line|
  match = /(.*)\(contains (.*)\)/.match(line)
  Food.new(match[1].split(/ /), match[2].split(/, /))
end

# possibilities[allergen] = set of ingredients it could have
possibilities = {}

foods.each do |food|
  food.allergens.each do |allergen|
    if possibilities.include?(allergen)
      possibilities[allergen] &= food.ingredients
    else
      possibilities[allergen] = Set.new(food.ingredients)
    end
  end
end

# allergen_mapping[allergen] = ingredient it must be in
allergen_mapping = {}

until possibilities.empty?
  next_allergen = possibilities.find { |(_allergen, ingredients)| ingredients.size == 1 }[0]
  next_ingredient = possibilities[next_allergen].to_a[0]

  allergen_mapping[next_allergen] = next_ingredient
  possibilities.delete(next_allergen)
  possibilities.each_value { |ingredients| ingredients.delete(next_ingredient) }
end

puts(allergen_mapping.to_a.sort.map { |x| x[1] }.join(','))
