# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Civility.create([{ name: 'M.' }, { name: 'Mme.' }])

Sex.create([{ name: 'M' }, { name: 'F' }])

CreationMode.create([{ name: 'WEB', token: '0504fe0b64c5e08d46c49ab41d33be94' }, { name: 'USSD', token: 'd2a29d336c48fe68df6e5827cc49a042' }])
