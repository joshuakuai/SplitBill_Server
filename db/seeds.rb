# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.delete_all

User.create(email: 'example@mail.com', password: 'textpassword', session_token: 'texttoken', balance: 0)
User.create(email: 'bearworldbrave@gmail.com', password: '123456', session_token: 'texttoken', balance: 0)