FactoryGirl.define do

	# 使用factory预构件定义了一个User模型
	# 'sequence'作用：调用一次FactoryGirl.create，则'n'就+1
	# 目的：为了自动生成大量的email不同的user用户
	# 用法：
	#     1.调用普通用户：FactoryGirl.create(:user)
	#     2.调用管理员：FactoryGirl.create(:admin)
	factory :user do
		sequence(:name) { |n| "person_#{n}" }
		sequence(:email){ |n| "person_#{n}@example.com" }
	    password              "123456"
	    password_confirmation "123456"

	    #创建admin管理员的方法
	    factory :admin do
	    	admin true
	    end
	end
end