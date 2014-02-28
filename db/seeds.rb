# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

me = User.find_by email: "etienne.garnier@provider.tld"
me.destroy! if me
User.create! first_name: "Etienne", last_name: "Garnier", email: "etienne.garnier@provider.tld"
