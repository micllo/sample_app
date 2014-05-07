module UsersHelper
   # 使用Gravatar(个人全球统一标识)可以简单的在网站中加入用户头像
   # 只要使用用户的Email地址构成头像的URL地址，关联的头像就可以显示出来
   # 返回指定用户的Gravatar头像(img元素)
   # 注：Email地址必须是example@railstutorial.org 头像才会有效，否则显示的是默认头像
   def gravatar_for(user, option = { size: 50 })
   	   gravatar_id = Digest::MD5::hexdigest(user.email.downcase) 
   	   size = option[:size]
   	   gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}.png?s=#{size}" 
   	   image_tag(gravatar_url, alt: user.name, class: "gravatar")
   end
end
