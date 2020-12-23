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

possible_ingredients = Set.new(possibilities.values.flat_map(&:to_a))

answer = 0
foods.each do |food|
  food.ingredients.each do |ingredient|
    answer += 1 unless possible_ingredients.include?(ingredient)
  end
end
p answer
