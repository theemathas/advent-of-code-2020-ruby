require 'set'

input = IO.read(File.join(__dir__, 'input.txt'))

are_passports_valid = input.split("\n\n").map do |passport|
  field_names = Set.new(passport.split(/\s+/).map do |field|
    field_parts = field.split(':')
    raise "Invalid field '#{field}'" unless field_parts.length == 2
    field_parts[0]
  end)

  required_fields = Set['byr', 'iyr', 'eyr', 'hgt', 'hcl', 'ecl', 'pid']
  allowed_fields = required_fields | Set['cid']

  raise "Unexpected fields '#{field_names}'" unless field_names <= allowed_fields

  field_names >= required_fields
end

p are_passports_valid.count(true)
