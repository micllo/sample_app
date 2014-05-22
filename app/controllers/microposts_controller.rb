
#【创建一条微博】
#【删除一条微博】（只用当前用户可以删除自己微博）

class MicropostsController < ApplicationController

	# 注：'signed_in_user'方法在'sessions_helper'中
	before_filter :signed_in_user, only: [ :create, :destroy ]
	before_filter :if_currect_user, only: :destroy

	def index
	end

	#【创建一条微博】
	def create
		@micropost = current_user.microposts.build(params[:micropost])
		
		if @micropost.save
			flash[:success] = "Micropost create!"
			redirect_to root_url
		else
			# 非法提交时需要赋个空值给@feed_items对象，否则该对象为nil时，页面会报错
			@feed_items = []
			render 'static_pages/home'
		end
	end


	#【删除一条微博】
	#（只用当前用户可以删除自己微博）
	def destroy
		@micropost.destroy
		redirect_to root_path
	end


	private
		# 判断要删除的是否为当前用户的微博
		def if_currect_user
			@micropost = current_user.microposts.find_by_id(params[:id])
			redirect_to root_path if @micropost.nil?
		end

end