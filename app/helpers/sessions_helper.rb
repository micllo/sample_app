module SessionsHelper

	# 登录操作
	def sign_in(user)

		# 将'remember_token'保存在'cookie'中，有效期设置为20年
		# rails将cookie方法的'permanent'默认设为20年
		cookies.permanent[:remember_token] = user.remember_token

		# 上面的代码等同于下面的代码
		# cookies[:remember_token] = { value: user.remember_token,expires:20.years.from_now.utc }

		# 将user设置为当前属性
		self.current_user = user
	end

	# 退出操作
	def sign_out
		cookies.delete(:remember_token)
		self.current_user = nil
	end


	#判断用户是否已登录
	def signed_in?

		# 只要不是nil就表示已登录
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
end
