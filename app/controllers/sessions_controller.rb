#【用户登录】
# 1.验证Email和Password是否存在
#   （1）判断：通过Email找的uesr用户是否存在
# 	（2）判断：验证password是否与找到的user用户中的密码一致（对比的是加密密码）
# 	（3）两个条件都要满足（即：都返回 true ）
# 2.验证通过后，将session信息保存入cookie中
#  （调用：app/helpers/sessions_helper.rb中的sign_in方法）
# 3.验证通过后，调用'helper'中的方法来确定重定向到哪个页面（确保更友好的转向）

#【用户退出】
#（清除cookie中的remember_token）


class SessionsController < ApplicationController

	#【用户登录】
	def new
	end

	#【用户登录】
	# 1.验证Email和Password是否存在
	#   （1）判断：通过Email找的uesr用户是否存在
	# 	（2）判断：验证password是否与找到的user用户中的密码一致（对比的是加密密码）
	# 	（3）两个条件都要满足（即：都返回 true ）
	# 2.验证通过后，将session信息保存入cookie中
	#  （调用：app/helpers/sessions_helper.rb中的sign_in方法）
	# 3.验证通过后，调用'helper'中的方法来确定重定向到哪个页面（确保更友好的转向）
	def create

		user = User.find_by_email(params[:session][:email].downcase)
		
		if user && user.authenticate(params[:session][:password])
			sign_in user
			redirect_back_or user
		else
			flash[:error] = "Invalid email/password combination" 
			render 'new'
		end
	end


	#【用户退出】
	#（清除cookie中的remember_token）
	def destroy
		sign_out 
		redirect_to root_path
	end

end
