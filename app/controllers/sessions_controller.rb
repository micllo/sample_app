class SessionsController < ApplicationController

	def new
	end

	# 登录（验证Email和Password是否存在）
	def create
		user = User.find_by_email(params[:session][:email].downcase)
		
		# 判断：通过Email找的uesr用户是否存在
		# 判断：验证password是否与找到的user用户中的密码一致（对比的是加密密码）
		# 两个条件都要满足（即：都返回 true ）
		if user && user.authenticate(params[:session][:password])
			
			# 调用app/helpers/sessions_helper.rb中的'sign_in'方法实现登录操作
			# 即：将user信息保存在cookie中
			sign_in user

			#【为什么会跳转至show页面】？？？？？
			redirect_to user
		else

			flash[:error] = "Invalid emali/password combination" 
			render 'new'
		end
	end

	# 退出
	def destroy
		# 将cookie中的remember_token删除	
		sign_out 
		redirect_to root_path
	end

end
