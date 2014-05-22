class StaticPagesController < ApplicationController
  
  # 已登录的用户'创建一个微博对象'和'获取当前用户的微博数组'传递到'home'页面
  def home
    if signed_in?
  	   @micropost = current_user.microposts.build
       @feed_items = current_user.feed.paginate(page: params[:page])
    end
  end


  def help
  end

  def about
  end

  def contact
  end
end
