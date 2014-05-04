FactoryGirl.define do

	# 使用factory定义了一个User模型
	factory :user do
	   name                  "miclloooo"
	   email                 "miclloooo@126.com"
	   password              "123456"
	   password_confirmation "123456"
	end

end