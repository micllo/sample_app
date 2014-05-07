
# 验证登录页面的标记内容
# 验证登录失败
# 验证登录成功
#    1.验证profile用户资料页面（Show页面）链接是否存在
#    2.验证退出链接是否存在
#    3.验证登录链接是否不存在
#    4.验证可以成功退出


require 'spec_helper'

describe "Authentication" do
 
   subject { page }

   # 验证登录页面的标记内容
   describe "signin page" do

      	before { visit signin_path }

  	  	it { should have_selector('h1', text: "Sign in") }
  	 	it { should have_selector('title', text: "Sign in") }
   end

   describe "signin" do
   		before { visit signin_path }

		# 验证登录失败
   		describe "with invalid information" do
   			before { click_button 'Sign in' }

   			it { should have_selector('title', text: 'Sign in') }
   			
            # 验证登录失败的提示信息
            # 调用spec/support/utilities.rb中的’have_error_message‘方法
   			it { should have_error_message('Invalid') }
   		end

   		# 验证登录成功
   		describe "with valid information" do
   			
            # 先在数据库中注册一个用户
   			# 调用Factory中定义的user数据模型(在spec/factories.rb中)
   			let(:user) { FactoryGirl.create(:user) }

            # 输入之前注册的用户信息进行登录
            # 调用spec/support/utilities.rb中的'valid_signin'方法
   			before { valid_signin(user) }

   			it { should have_selector('title', text: user.name)}
   			
   			# 验证profile用户资料页面（Show页面）链接是否存在
   			it { should have_link('Profile', href: user_path(user)) }
   			
   			# 验证退出链接是否存在
   			it { should have_link('Sign out', href: signout_path) }
   			
   			# 验证登录链接是否不存在
   			it { should_not have_link('Sign in'), href: signin_path }
            
            # 验证可以成功退出
            describe "followed by signout" do
               before { click_link 'Sign out' }
               
               it { should have_link('Sign in', href: signin_path) }
            end
   		end
   end
end
