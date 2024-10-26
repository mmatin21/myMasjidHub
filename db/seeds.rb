# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

test_masjid = Masjid.create(address: "Test Address", city: "Test City", state: "Test State",
 zipcode: "Test Zip", phone_number: "1234567890", email: "test@test.com", password: "test", password_confirmation: "test")