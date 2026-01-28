# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
puts "Seeding users..."

users = [
  {
    email: "admin@example.com",
    role: :admin
  },
  {
    email: "reviewer@example.com",
    role: :reviewer
  },
  {
    email: "readonly@example.com",
    role: :read_only
  }
]

users.each do |attrs|
  user = User.find_or_initialize_by(email: attrs[:email])

  user.role = attrs[:role]
  user.time_zone ||= "Asia/Kolkata"

  # Set password only if new record
  if user.new_record?
    user.password = "Password@123"
    user.password_confirmation = "Password@123"
  end

  user.save!
  puts "✔ Created/Updated #{attrs[:role]} user: #{attrs[:email]}"
end

puts "Seeding complete."
