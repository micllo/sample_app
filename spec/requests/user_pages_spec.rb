
#【'it'测试方法的原理】
# 	1.进入'it'时，会先去调用before方法中的内容（可以创建用户数据）
# 	2.退出'it'时，会自动去完整的清除用户数据（即：数据模型中自动创建的'id'字段也一并清除）

#【注】
#  1.当有多个'it'平级时，执行'it'的顺序是随机的
#  2.当有多个'describe'平级时，执行'describe'的顺序是随机的
#  3.当'describe'和'it'是平级时，总是先执行'it'，再执行'describe'

#【'let' 和'let!'的区别】
# 'let'指定的变量是“惰性”的，只有当后续引用时才会被创建
# 'let!'则可以强制相应的变量立即被创建

# *********************************************************************

#【用户页面测试】

#【注册页面的标记验证】

#【注册功能验证】
# 1.验证注册失败后，数据库中的记录数量是否没有改变
# 2.验证注册成功后，数据库中的记录数量是否已改变
# 3.验证注册成功后，是否会跳转至登录后的profile页面
#   1）验证title标记内容
#   2）验证跳转至profile页面时，是否会显示注册成功的提示信息
#   3）验证signout链接是否存在
# 4.验证注册失败后，是否会出现错误提示信息
#   1）验证title标记内容
#   2）验证是否会显示注册失败的提示信息

#【编辑功能验证】
# 1.验证编辑页面的标记
# 2.验证编辑失败后，是否显示错误提示信息
# 3.验证编辑成功后：
#   1）title的内容是否已经改变
#   2）是否存在更新成功的div标记
#   3）是否仍然是登录状态
#   4）用户的name属性是否确实已经改变
#   5）用户的email属性是否确实已经改变

#【用户列表验证】
# 1.验证index页面中的标记内容
# 2.验证分页功能
#   1）验证是否有分页的标签
#   2）验证第一页的用户名是否正确
# 3.验证删除用户功能
# 	1）普通用户不能看到删除链接
#   2）管理员可以看到删除链接
#   3）管理员不能看到自己的删除链接
#   4）管理员可以成功删除其他用户

#【用户发布微博】
# 1.验证用户资料页是否显示了微博内容
# 	1）验证用户资料页是否统计了该用户的微博数量
#   2）验证用户资料页是否显示了该用户发布的微博内容


require 'spec_helper'

describe "User Pages" do

	subject { page }

	# 将所有相同的验证方法存放入共享模块中（验证标记内容）
	shared_examples_for "h1_title" do
		it { should have_selector('h1', text: h1) }
		it { should have_selector('title', text: title) }
	end

	shared_examples_for "title" do
		it { should have_selector('title', text: title) }
	end


	#【注册页面的标记验证】
	# 调用共享模块中的验证方法
	describe "signup page" do

		before { visit signup_path }
		let(:h1) { 'Sign up' }
		let(:title) { 'Sign up' }

		it_should_behave_like "h1_title"
	end


	#【注册功能验证】
	# 1.验证注册失败后，数据库中的记录数量是否没有改变
	# 2.验证注册成功后，数据库中的记录数量是否已改变
	# 3.验证注册成功后，是否会跳转至登录后的profile页面
	#   1）验证title标记内容
	#   2）验证跳转至profile页面时，是否会显示注册成功的提示信息
	#   3）验证signout链接是否存在
	# 4.验证注册失败后，是否会出现错误提示信息
	#   1）验证title标记内容
	#   2）验证是否会显示注册失败的提示信息
	describe "signup" do

		before { visit signup_path }
		let(:submit) { "Create my account" }

		# 1.验证注册失败后，数据库中的记录数量是否没有改变
		describe "with invalid information" do

			it "should not create a user" do

				# 比较点击按钮前与点击按钮后，User模型的数量是否未改变
				# ’change‘方法，第一个参数是对象名，第二个参数是Symbol，(即：User.count)
				expect { click_button submit }.not_to change(User, :count)
			end
		end


		# 2.验证注册成功后，数据库中的记录数量是否已改变
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


			# 3.验证注册成功后，是否会跳转至登录后的profile页面
			#   1）title标记内容
			#   2）跳转至profile页面时，是否会显示注册成功的提示信息
			#   3）signout链接是否存在
			describe "after saving user" do

				before { click_button submit }
				let(:user){ User.find_by_email("micllo@126.com") }
				let(:title) { user.name }

				it_should_behave_like "title"
            	# 调用’have_success_message‘方法在（spec/support/utilities.rb中）
   				it { should have_success_message('Welcome') }
				it { should have_link('Sign out') }
			end
		end


		# 4.验证注册失败后，是否会出现错误提示信息
		#   1）title标记内容
		#   2）是否会显示注册失败的提示信息
		describe "should have error information" do

			before { click_button submit }

			let(:title) { 'Sign up' }
			it_should_behave_like "title"

			it { should have_content('error') }
		end
	end


	#【编辑功能验证】
	# 1.编辑页面的标记验证
	# 2.验证编辑失败后，是否显示错误提示信息
	# 3.验证编辑成功后：
	#   1）title的内容是否已经改变
	#   2）是否存在更新成功的div标记
	#   3）是否仍然是登录状态
	#   4）用户的name属性是否确实已经改变
	#   5）用户的email属性是否确实已经改变
	describe "edit" do

		let(:user){ FactoryGirl.create(:user) }

		# 先登录再编辑
		before do
			sign_in user
			visit edit_user_path(user) 
		end

		# 1.验证编辑页面的标记
		describe "page" do
			it { should have_selector('h1', text: "Update your profile") }
			it { should have_selector('title', text: "Edit user") }
			it { should have_link('change', href: "http://gravatar.com/emails") }
		end

		# 2.验证编辑失败后，是否显示错误提示信息
		describe "with invalid information" do

			before { click_button "Save changes" }
			it { should have_content("error") }
		end

		# 3.验证编辑成功后：
		#   1）title的内容是否已经改变
		#   2）是否存在更新成功的div标记
		#   3）是否仍然是登录状态
		#   4）用户的name属性是否确实已经改变
		#   5）用户的email属性是否确实已经改变
		describe "with valid information" do
			let(:new_name){ "new_name" }
			let(:new_email){ "new_email@126.com" }

			before do
				fill_in "Name", 		with: new_name
				fill_in "Email", 		with: new_email
				fill_in "Password", 	with: user.password
				fill_in "Confirmation", with: user.password
				click_button "Save changes"
			end

			it { should have_selector('title', text: new_name) }
			it { should have_selector('div.alert.alert-success') }
			it { should have_link('Sign out', href: signout_path) }
			specify { user.reload.name.should == new_name }
			specify { user.reload.email.should == new_email }
		end
	end


	#【用户列表验证】
	# 1.验证index页面中的标记内容
	# 2.验证分页功能
	#   1）验证是否有分页的标签
	#   2）验证第一页的用户名是否正确
	describe "index" do

		let(:user){ FactoryGirl.create(:user) }

		before (:each) do 
			sign_in user
			visit users_path
		end

		# 1.验证index页面中的标记内容
		it { should have_selector('title', text: "All users") }
		it { should have_selector('h1', text: "All users") }


		# 2.验证分页功能
		#   1）验证是否有分页的标签
		#   2）验证第一页默认的30个用户名是否正确
		describe "pagination" do

			# 在块中所有测试执行前，一次创建30个示例用户
			# 注意：此时正好有31个用户，所以才会出现翻页控件
			before(:all){ 30.times{ FactoryGirl.create(:user) } }

			# 在块中所有测试执行后，一次删除所有示例用户
			#【注】这里不会删除数据模型自动生成的'id'字段的值
			after(:all){ User.delete_all }

			it { should have_selector('div.pagination') }

			it "should list each user" do
				User.paginate(page: 1).each do |user|
					should have_selector('li', text: user.name) 
				end
			end
		end

		# 3.验证删除用户功能
		# 	1）普通用户不能看到删除链接
		#   2）管理员可以看到删除链接
		#   3）管理员不能看到自己的删除链接
		#   4）管理员可以成功删除其他用户
		describe "delete links" do

			it { should_not have_link('delete') }

			describe "as a admin user" do
				let(:admin) { FactoryGirl.create(:admin) }
				
				before do
					sign_in admin
					visit users_path
				end

				it { should have_link('delete', href: user_path(User.first)) }
				it { should_not have_link('delete', href: user_path(admin)) }

				it "should be able to delete another user" do
					expect { click_link('delete') }.to change(User, :count).by(-1)
				end
			end
		end
	end

	#【用户发布微博】
	# 1.验证用户资料页是否显示了微博内容
	# 	1）验证用户资料页是否统计了该用户的微博数量
	#   2）验证用户资料页是否显示了该用户发布的微博内容
	describe "profile page" do

		let(:user) { FactoryGirl.create(:user) }
		let!(:m1)  { FactoryGirl.create(:micropost, user: user, content: "Foo") }
		let!(:m2)  { FactoryGirl.create(:micropost, user: user, content: "Bar") }

		before { visit user_path(user) } 

		let(:h1)    { user.name }
		let(:title) { user.name }

		# 验证profile页面标记(调用共享模块中的验证方法)
		it_should_behave_like "h1_title"

		describe "microposts" do
		    it { should have_content(user.microposts.count) }
		 	it { should have_content(m1.content) }
		 	it { should have_content(m2.content) }
		end

	end



























end
