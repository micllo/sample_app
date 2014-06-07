namespace :db do
	desc "Fill database with sample data" 
	task populate: :environment do
		make_users
		make_microposts
		make_relationships
	end
end


def make_users
	admin = User.create!(name: "Example User",
				 		 email: "example@railstutorial.org",
               	 		 password: "foobar",
				 		 password_confirmation: "foobar") 
	# 将第一个用户设置为管理员
	admin.toggle!(:admin)

	99.times do |n|
		name 	 = Faker::Name.name
		email 	 = "example-#{n+1}@railstutorial.org" 
		password = "password"
		User.create!(name: name,
					 email: email,
					 password: password,
					 password_confirmation: password)
	end 
end


# 为前6个用户，每人创建50篇微博
def make_microposts
	users = User.all(limit: 6)
	50.times do
		content = Faker::Lorem.sentence(5)
		users.each { |user| user.microposts.create!(content: content) }
	end
end


# 将第一个用户关注，第3到第51个用户
# 将第4到第41个用户，关注第一个用户
def make_relationships
	users = User.all
	user  = users.first

	followed_users = users[2..50]
	followers 	   = users[3..40]

	followed_users.each { |followed| user.follow!(followed) }
	followers.each      { |follower| follower.follow!(user) }
end






