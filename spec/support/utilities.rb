# 该文件目的：为RSpec测试提供方法，供其他文件调用

# 引用app/helpers/application_helper.rb中的modul方法
include ApplicationHelper

# 登录操作
def sign_in(user)
	visit signin_path
	fill_in "Email", with: user.email 
	fill_in "Password", with: user.password 
	click_button "Sign in"
	cookies[:remember_token] = user.remember_token
end


# 验证登录失败的提示信息
RSpec::Matchers.define :have_error_message do |message| 
	match do |page|
		expect(page).to have_selector('div.alert.alert-error', text: message) 
	end
end


# 验证注册成功的提示信息
RSpec::Matchers.define :have_success_message do |message| 
	match do |page|
		expect(page).to have_selector('div.alert.alert-success', text: message) 
	end
end



