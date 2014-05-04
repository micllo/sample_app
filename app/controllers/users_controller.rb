class UsersController < ApplicationController
  
  def new
  	@user = User.new
  end

  def show
  	@user = User.find(params[:id])
  end

  def create
  	@user = User.new(params[:user])
  	if @user.save
  		flash[:success] = "welcome to the Sample App!"
  		# 页面重定向
  		redirect_to @user 
  	else
  		# 页面的回调（即：输入框保留着原有的内容）
  		render 'new' 
  	end
  end

end
