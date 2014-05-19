
#【验证页面测试】

#【登录页面的标记验证】

#【登录功能验证】
# 1.验证登录失败
#   1）验证登录失败后的title标记
#   2）验证登录失败后的错误提示信息

# 2.验证登录成功
#   1）验证登录成功后的title标记
#   2) 验证users链接是否存在
#   3）验证profile链接是否存在
#   4）验证setting链接是否存在
#   5）验证signout链接是否存在
#   6）验证signin链接是否不存在
#   7）验证是否可以成功退出（退出后，验证signin链接是否存在）

#【用户权限验证】
#（针对：'edit'、'update'、'index'）
# 1.验证必须登录后，才能编辑用户资料和访问用户列表页面
#   1）未登录情况下直接进入编辑页面，是否会跳转到登录页面
#   2）未登录情况下直发送接提交表单的http请求(PUT)，是否会跳转到登录页面
#   3）未登录情况下直接访问用户列表，是否会跳转到登录页面
# 2.更友好的转向：
#   第一步：未登录的情况下编辑用户后会跳转到了登录页面
#   第二步：成功登录后，应该直接进入用户编辑页面，而不是用户展示页面
# 3.验证登录的当前用户不能编辑其他用户的资料
#   1）用户登陆后，进入其他用户的编辑页面，'title'不应该显示'Edit user'(不应该进入编辑页面)
#   2）用户登录后，直接发送其他用户的提交表单的http请求(PUT)，是否会跳转至首页
# 4.验证登录的非管理员不可以删除其他用户（防止黑客直接使用'DELETE'请求进行恶意删除）
# 5.验证登录的管理员不可以删除自己



require 'spec_helper'

describe "Authentication" do
 
   subject { page }

   #【登录页面的标记验证】
   describe "signin page" do

      before { visit signin_path }
  	  	it { should have_selector('h1', text: "Sign in") }
  	 	it { should have_selector('title', text: "Sign in") }
   end


   #【登录功能验证】
   describe "signin" do

   	before { visit signin_path }

		#【验证登录失败】
      # 1.验证登录失败后的title标记
      # 2.验证登录失败后的错误提示信息
      # （调用spec/support/utilities.rb中的’have_error_message‘方法）
   	describe "with invalid information" do

   		before { click_button 'Sign in' }
   		it { should have_selector('title', text: 'Sign in') }
   		it { should have_error_message('Invalid') }
   	end


   	#【验证登录成功】
      # 先在数据库中注册一个用户：调用Factory中定义的user数据模型(在spec/factories.rb中)
      # 输入之前注册的用户信息进行登录操作：调用'sign_in'方法（spec/support/utilities.rb中）
      # 1.验证登录成功后的title标记
      # 2.验证users链接是否存在
      # 3.验证profile链接是否存在
      # 4.验证setting链接是否存在
      # 5.验证signout链接是否存在
      # 6.验证signin链接是否不存在
      # 7.验证是否可以成功退出（退出后，验证signin链接是否存在）
   	describe "with valid information" do

   		let(:user) { FactoryGirl.create(:user) }
			before { sign_in(user) }

   		it { should have_selector('title', text: user.name)}	
         it { should have_link('Users', href: users_path) }
			it { should have_link('Profile', href: user_path(user)) }
         it { should have_link('Settings', href: edit_user_path(user)) }  			
   		it { should have_link('Sign out', href: signout_path) }		
  			it { should_not have_link('Sign in'), href: signin_path }
            
         describe "followed by signout" do
            before { click_link 'Sign out' }            
            it { should have_link('Sign in', href: signin_path) }
         end
  		end
   end


   #【用户权限验证】
   #（针对：'edit'、'update'、'index'）
   describe "authentication" do

      # 1.验证必须登录后，才能编辑用户资料和访问用户列表页面
      #   1）未登录情况下直接进入编辑页面，是否会跳转到登录页面
      #   2）未登录情况下直发送接提交表单的http请求(PUT)，是否会跳转到登录页面
      #   3）未登录情况下直接访问用户列表，是否会跳转到登录页面
      describe "for non-signed-in users" do

         let(:user) { FactoryGirl.create(:user) }

         describe "in the Users controller" do

            # 1）未登录情况下直接进入编辑页面，是否会跳转到登录页面
            describe "visiting the edit page" do
               before { visit edit_user_path(user) }
               it { should have_selector('title', text: 'Sign in') }
            end

            # 2）未登录情况下直发送接提交表单的http请求(PUT)，是否会跳转到登录页面
            describe "submitting to the update action" do
               before { put user_path(user) }
               specify { response.should redirect_to(signin_path) }
            end

            # 3）未登录情况下直接访问用户列表，是否会跳转到登录页面
            describe "visiting the user index" do
               before { visit users_path }
               it { should have_selector('title', text: "Sign in") }
            end

         end

         # 2.更友好的转向：
         #   第一步：未登录的情况下编辑用户后会跳转到了登录页面
         #   第二部：成功登录后，应该直接进入用户编辑页面，而不是用户展示页面
         describe "when attempting to visit a protected page" do
            before do
               visit edit_user_path(user)
               fill_in "Email",    with: user.email
               fill_in "Password", with: user.password
               click_button "Sign in"
            end

            describe "after signing in" do
               it "should render the desired protected page" do
                  should have_selector('title', text: "Edit user") 
               end
            end
         end
      end

       # 3.验证登录的当前用户不能编辑其他用户的资料
       #   1）用户登陆后，进入其他用户的编辑页面，'title'不应该显示'Edit user'(不应该进入编辑页面)
       #   2）用户登录后，直接发送其他用户的提交表单的http请求(PUT)，是否会跳转至首页
      describe "as wrong user" do

         let(:user){ FactoryGirl.create(:user) }
         let(:wrong_user){ FactoryGirl.create(:user, email: "wrong@126.com") }
         before { sign_in(user) }

         describe "visiting Users#edit page" do
            before { visit edit_user_path(wrong_user) }
            it { should_not have_selector('title', text: "Edit user") }
         end

         describe "submitting to PUT request to the Users#update action" do
            before { put user_path(wrong_user) }
            specify { response.should redirect_to(root_path) }
         end
      end

      # 4.验证登录的非管理员不可以删除其他用户
      #  （防止黑客直接使用'DELETE'请求进行恶意删除）
      describe "as non-admin user" do

         let(:user){ FactoryGirl.create(:user) }
         let(:non_admin){ FactoryGirl.create(:user) }

         before { sign_in non_admin }

         describe "submitting a DELETE request to the Users#destroy action" do
            before { delete user_path(user) }
            specify { response.should redirect_to(root_path) }
         end
      end

      # 5.验证登录的管理员不可以删除自己
      describe "as admin user" do
         let(:admin) { FactoryGirl.create(:admin) }
         before { sign_in admin }

         describe "submitting a DELETE request to destroy self" do
            before { delete user_path(admin) }
            specify { response.should redirect_to(root_path) }
         end
      end
   end


   # 验证已经登录的用户，不需要再访问'new'和'create'动作了
   describe "the signined user" do

      let(:user) { FactoryGirl.create(:user) }
      before { sign_in user }

      describe "no necessary to visit User#new action" do
         before { visit signup_path }
         it { should have_selector('h1', text: 'Welcome ') }
      end

      describe "no necessary to visit User#create action" do
         before { post users_path }
         specify { response.should redirect_to(root_path) }
      end
   end

end
