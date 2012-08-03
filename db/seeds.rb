# encoding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

unless Rails.env.production?
  existing = User.find_by_email("admin@holderdeord.no")
  existing && existing.destroy

  User.create!(:email => "admin@holderdeord.no", :password => "hdo123", :password_confirmation => "hdo123", :remember_me => false)
end

initial_fields_list = [
  "Offentlig forvaltning",
  "Familie og tro",
  "Kultur og frivillighet",
  "Helse og sosial",
  "Sjø og landbruk",
  "Energi og miljø",
  "Utenriks og sikkerhet",
  "Utdanning og forskning",
  "Finanser og næringsliv",
  "Arbeidsliv",
  "Transport og komm.",
  "Diverse"
]

puts 'Deleting all fields!'
Field.find_each(&:delete)

initial_fields_list.each do |field_name|
  puts "Creating field #{field_name}"
  Field.create! name: field_name
end

