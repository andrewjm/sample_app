# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

# To execute this run:
# bundle exec rake db:seed

# And to reset db run:
# bundle exec rake db:migrate:reset

User.create!(name:  "Example User",			# create one admin user
             email: "example@railstutorial.org",
             password:              "foobar",
             password_confirmation: "foobar",
	     admin: true,
             activated: true,
             activated_at: Time.zone.now)

99.times do |n|						# do the following 99 times
  name  = Faker::Name.name				# faker gem defines the name
  email = "example-#{n+1}@railstutorial.org"		# set email with incrementing address
  password = "password"					# set pw
  User.create!(name:  name,				# create the user
               email: email,
               password:              password,
               password_confirmation: password,
               activated: true,
               activated_at: Time.zone.now)
end

users = User.order(:created_at).take(6)			# take the 6 oldest users (the first 6 created)
50.times do						# make 50 microposts for each of them
  content = Faker::Lorem.sentence(5)
  users.each { |user| user.microposts.create!(content: content) }
end

# Following relationships
users = User.all					# greab all users
user  = users.first					# great first user
following = users[2..50]				# array of users 2-50 named 'following'
followers = users[3..40]				# array of users 3-40 names 'followers'
following.each { |followed| user.follow(followed) }	# set first user to follow users 2-50
followers.each { |follower| follower.follow(user) }	# set users 3-40 to follow first user
