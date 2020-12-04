require 'set'

input = IO.read(File.join(__dir__, 'input.txt'))

def passport_valid?(passport)
  raise 'expected string' unless passport.is_a? String

  fields = Set.new(passport.split(/\s+/).map do |field_string|
    field_parts = field_string.split(':')
    raise "Invalid field '#{field_string}'" unless field_parts.length == 2
    field_parts
  end)

  field_names = Set.new(fields.map { |field| field[0] })

  required_fields = Set['byr', 'iyr', 'eyr', 'hgt', 'hcl', 'ecl', 'pid']
  allowed_fields = required_fields | Set['cid']

  raise "Unexpected fields '#{field_names}'" unless field_names <= allowed_fields

  field_names >= required_fields and fields.all? { |field| field_valid?(*field) }
end

def field_valid?(name, value)
  case name
  when 'byr'
    value.match?(/^\d{4}$/) and (1920..2002).include?(Integer(value, 10))
  when 'iyr'
    value.match?(/^\d{4}$/) and (2010..2020).include?(Integer(value, 10))
  when 'eyr'
    value.match?(/^\d{4}$/) and (2020..2030).include?(Integer(value, 10))
  when 'hgt'
    match = value.match(/([1-9]\d*)(in|cm)/)
    if match
      num = Integer(match[1], 10)
      unit = match[2]
      (
        (unit == 'cm' and (150..193).include?(num)) or
        (unit == 'in' and (59..76).include?(num))
      )
    else
      false
    end
  when 'hcl'
    value.match?(/^\#[0-9a-f]{6}$/)
  when 'ecl'
    Set['amb', 'blu', 'brn', 'gry', 'grn', 'hzl', 'oth'].include?(value)
  when 'pid'
    value.match?(/^\d{9}$/)
  when 'cid'
    true # Always valid
  else
    raise "unknown field #{name}"
  end
end

p input.split("\n\n").map { |passport| passport_valid?(passport) }.count(true)
