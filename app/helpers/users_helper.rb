module UsersHelper
   # 使用Gravatar(个人全球统一标识)可以简单的在网站中加入用户头像
   # 只要使用用户的Email地址构成头像的URL地址，关联的头像就可以显示出来
   # 返回指定用户的Gravatar头像(img元素)
   def gravatar_for(user)
   	   gravatar_id = Digest::MD5::hexdigest(user.email.downcase) 
   	   gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}" 
   	   image_tag(gravatar_url, alt: user.name, class: "gravatar")
   end
end
