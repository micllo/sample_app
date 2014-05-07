class UsersController < ApplicationController
  
  def new
  	@user = User.new
  end

  def show
  	@user = User.find(params[:id])
  end

  # 将注册用户信息提交至数据库中
  def create
  	@user = User.new(params[:user])
  	if @user.save

      # 注册成功后直接登录（将user的remember_token存入cookie）
      sign_in @user

  		flash[:success] = "Welcome to the Sample App!"

  		# 页面重定向至 'UsersControll#show'
      # redirect_to user_path(@user) 
  		redirect_to @user  
  	else
  		# 页面的回调（即：输入框保留着原有的内容）
  		render 'new' 
  	end
  end

end
