
# 注：从controller传递参数到view中显示时，一般只能默认传递一个（即：@user）
#    如果希望传递两个参数到view的话，就需要用到‘helper’
#    而这里的@current_user是不能直接从controller直接传递到view的
#    因为当页面重定向时，@current_user的生命周期就结束了
#    所以需要通过cookie来获取@current_user的值

module SessionsHelper

	#【登录操作】
	# 1.将'remember_token'保存在'cookie'中，有效期设置为20年
	#  （rails将cookie方法的'permanent'默认设为20年）
	# 2.将user设置为当前属性
	def sign_in(user)

		cookies.permanent[:remember_token] = user.remember_token
		# 上面的代码等同于下面的代码
		# cookies[:remember_token] = { value: user.remember_token,expires:20.years.from_now.utc }

		self.current_user = user
	end


	#【退出操作】
	def sign_out
		cookies.delete(:remember_token)
		self.current_user = nil
	end


	#【判断用户是否已登录】
	# 只要不是nil就表示已登录
	def signed_in?
		! current_user.nil?  
	end


	# 可写入当前的user属性
	def current_user= (user)
		@current_user = user
	end


	# 可读取当前的user属性
	def current_user
		# ”|| = “ 表示:
		# 如果'current_user'存在就直接读取user信息
		# 如果不存在，则通过cookie中的token来获取user信息后，再读取
		@current_user ||= User.find_by_remember_token(cookies[:remember_token])
		# 上面代码等同于下面代码
		# @current_user = @current_user || User.find_by_remember_token(cookies[:remember_token])
	end

	# 判断该用户是否为当前用户
	def current_user?(user)
		user == current_user
	end

	# 保存当前的url请求地址
	def store_location
		session[:return_to] = request.fullpath
	end

	# 重定向到之前的url请求地址
	def redirect_back_or(default)
		redirect_to(session[:return_to] || default)
		session.delete(:return_to)
	end

end
