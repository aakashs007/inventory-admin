# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
UserType.create!(role: 0)
UserType.create!(role: 1)
UserType.create!(role: 2)
UserType.create!(role: 3)
UserType.create!(role: 4)
UserType.create!(role: 5)

AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password', user_type_id: 1) if Rails.env.development?