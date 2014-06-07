
#【关注用户】
#【取消关注】

#【在js.erb页面中的注释】

# 一【jQuary方法】
# 	1.$('#follow_form')方法：通过div中的id标记来获取DOM元素（Document Object Model）
# 					        这个DOM元素指的是包含表单的div，而不是表单本身
# 	2.html()方法：使参数中指定的html内容，取代原有DOM元素中包含的html内容

# 二【create.js.erb】 
# 	1.将原有show页面中“关注”按钮替换成“取消关注”按钮
#  	 （'views/users/_follow_form.html.erb'中的 <div id = "follow_form"> ）
# 	2.将原有show页面中的用户“粉丝数量”重新统计一次
#  	 （'views/shared/_stats.html.erb'中的 <strong id = "followers" class = "stat"> )

# 三【destroy.js.erb】
# 	1.将原有show页面中“取消关注”按钮替换成“关注”按钮
#    （'views/users/_follow_form.html.erb'中的 <div id = "follow_form"> ）
# 	2.将原有show页面中的用户“粉丝数量”重新统计一次
#    （'views/shared/_stats.html.erb'中的 <strong id = "followers" class = "stat"> )


class RelationshipsController < ApplicationController

	# 判断先登录
	before_filter :signed_in_user

	#【关注用户】
	# 通过表单传送过来的'relationship'对象的'followed_id'
	# 来获取被关注的用户对象
	def create
		@user = User.find(params[:relationship][:followed_id])
		current_user.follow!(@user)

		# 当接到普通的'HTTP'请求时，会执行第一行
		# 当接到'remote:true'的'Ajax'请求时，会执行第二行
		# 在处理'Ajax'请求时，Rails会自动调用文件名和action名一样的文件（即：'views/relationships/create.js.erb'）
		# 同时页面不作跳转，而是直接通过'create.js.erb'对原来的show页面中的部分元素进行修改
		respond_to do |format|
			format.html {redirect_to @user }
			format.js
		end
	end


	#【取消关注】
	# 'Relationship.find(params[:id])'         
	#  返回的是：一条relationship的记录（'follower_id'当前用户ID、'followed_id'当前用户资料页面的用户ID）
	# 'Relationship.find(params[:id]).followed'返回的是：
	#  返回的是：'followed_id'所对应的'User'信息
	def destroy
		@user = Relationship.find(params[:id]).followed
		current_user.unfollow!(@user)
		respond_to do |format|
			format.html {redirect_to @user }
			format.js
		end
	end

end










