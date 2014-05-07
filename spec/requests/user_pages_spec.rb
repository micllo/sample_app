
#【测试注册页面相应的标记内容】
#【测试show页面相应的标记内容】
#【测试注册页面与数据库的交互】
# （1）验证注册失败后，数据库中的记录数量是否没有改变
# （2）验证注册失败后，数据库中的记录数量是否已改变
# （3）验证注册失败后，是否会出现错误提示信息
# （4）验证注册成功后，是否会跳转至show页面



require 'spec_helper'

describe "User Pages" do

	subject { page }

	# 验证注册页面相应的标记内容
	describe "signup page" do

		before { visit signup_path }

		it { should have_selector('h1', text: 'Sign up') }
		it { should have_selector('title', text: 'Sign up') }
	end

	# 验证show页面相应的标记内容
	describe "profile page" do

		# 调用Factory中定义的user数据模型(在sped/factories.rb中)
		let(:user) { FactoryGirl.create(:user) }
		before { visit user_path(user) }

		it { should have_selector('h1', text: user.name) }
		it { should have_selector('title', text: user.name) }
	end

	# 验证注册页面与数据库的交互
	describe "signup" do

		before { visit signup_path }

		# 代码的重构
		let(:submit) { "Create my account" }

		# 验证注册失败后，数据库中的记录数量是否没有改变
		# 不输入注册信息，点击提交按钮
		describe "with invalid information" do

			it "should not create a user" do

				# 比较点击按钮前与点击按钮后，User模型的数量是否未改变
				# ’change‘方法，第一个参数是对象名，第二个参数是Symbol，(即：User.count)
				expect { click_button submit }.not_to change(User, :count)

			end
		end

		# 验证注册成功后，数据库中的记录数量是否已改变
		# 正确输入注册信息后，点击提交按钮
		describe "with valid information" do

			#【注意：fill_in 后面的名称必须和页面元素名称保持一致】
			before do
				fill_in "Name",         with: "micllo"
				fill_in "Email",        with: "micllo@126.com"
				fill_in "Password",     with: "123456"
				fill_in "Confirmation", with: "123456"
			end

			it "should create a user" do
				expect { click_button submit }.to change(User, :count).by(1)
			end

			# 验证注册成功后，是否会跳转至登录后的show页面
			describe "after saving user" do
				before { click_button submit }
				let(:user){ User.find_by_email("micllo@126.com") }

				it { should have_selector('title', text: user.name) }
				# 验证注册成功后跳转至show页面的提示信息
				it { should have_selector('div.alert.alert-success', text: 'Welcome') }

				it { should have_link('Sign out') }
			end
		end

		# 验证注册失败后，是否会出现错误提示信息
		describe "should have error information" do
			before { click_button submit }

			it { should have_selector('title', text: 'Sign up') }
			it { should have_content('error') }
		end
	end
end
