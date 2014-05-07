# 该文件目的：提供方法，供其他文件调用

# 引用app/helpers/application_helper.rb中的modul方法
include ApplicationHelper


def valid_signin(user)
	fill_in "Email", with: user.email 
	fill_in "Password", with: user.password 
	click_button "Sign in"
end


RSpec::Matchers.define :have_error_message do |message| 
	match do |page|
		page.should have_selector('div.alert.alert-error', text: message) 
	end
end


