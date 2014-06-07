#【注册用户】
#【展示用户】（微博分页显示）
#【编辑用户】
#【显示用户列表】（用户分页显示）
#【删除用户】（只有以管理员身份登录后，才能删除其他用户）
#【展示关注列表】
#【展示粉丝列表】

#【用户权限的限制】
# 1.必须登录后才能编辑用户
# 2.更友好的转向
#   第一步：未登录的情况下编辑用户后会跳转到了登录页面
#   第二步：成功登录后，应该直接进入用户编辑页面，而不是用户展示页面 
# 3.登录的当前用户不能编辑其他用户
# 4.登录的非管理员不可以删除其他用户
# 5.登录的管理员不可以删除自己


class UsersController < ApplicationController

    # 在执行'action'之前需要先执行的方法
    # 注：'signed_in_user'方法在'sessions_helper'中
    before_filter :signed_in_user,  only: [:index, :edit, :update, :destroy, :following, :followers]
    before_filter :if_current_user, only: [:edit, :update]
    before_filter :admin_user,      only: [:destroy]
    before_filter :have_signed,     only: [:new, :create]

    #【显示用户列表】（用户分页显示）
    # 需要将使用分页的'@users'对象传递给'index'页面
    # 'paginate'方法返回的是'ActiveRecord::Relation'类对象
    # 'params[:page]'默认为30个
    def index
        @users = User.paginate(page: params[:page])
    end
    
    #【注册用户】
    def new
       	@user = User.new
    end


    #【将注册用户信息提交至数据库中】
    # 注册成功后直接登录（将user的remember_token存入cookie）
    def create
      	@user = User.new(params[:user])
    	if @user.save
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


    #【展示用户】(微博分页显示)
    # 需要将使用分页功能的'@microposts'对象传递给'show'页面
    # 用法同'index'方法
    def show
       @user = User.find(params[:id])
       @microposts = @user.microposts.paginate(page: params[:page])
    end


    # 【编辑用户】
    def edit 
    end


    #【将编辑的用户信息更新入数据库】
    # 注：更新后会重新生成一个remember_token，之前的session会失效
    #    所以需要重新保存一下session，防止会话劫持
    def update 
      if @user.update_attributes(params[:user])
         flash[:success] = "Profile updated"
         sign_in @user
         redirect_to @user
      else
         render 'edit'
      end
    end 


    #【删除用户】
    # （只有以管理员身份登录后，才能删除其他用户）
    def destroy
      user = User.find(params[:id])
      # 判断删除的用户是否为管理员自己
      if user.admin?
        redirect_to root_path
      else
         user.destroy
         flash[:success] = "User destroy"
         redirect_to users_path
      end
    end

    #【展示关注列表】
    def following
      @title = "Following"
      @user = User.find(params[:id])
      @users = @user.followed_users.paginate(page: params[:page])
      render 'show_follow'
    end

    #【展示粉丝列表】
    def followers
      @title = "Followers"
      @user = User.find(params[:id])
      @users = @user.followers.paginate(page: params[:page])
      render 'show_follow'
    end



    #【注意】私有方法一定要放在最下面
    private 

      # 判断用户是否已登录
      # 目的：已登录的用户访问'new'或'create'时直接跳转至首页
      def have_signed
        redirect_to root_path if signed_in?
      end

      # 判断进入编辑页面的是否为当前用户
      def if_current_user
         @user = User.find(params[:id])
         redirect_to(root_path) unless current_user?(@user)
      end

      # 判断当前用户是否为管理员
      def admin_user
        redirect_to(root_path) unless current_user.admin?
      end
end
