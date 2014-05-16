source 'https://rubygems.org'

gem 'rails', '3.2.13'

gem 'jquery-rails', '2.0.2'

# 'Bootstrap'框架可以把精美的Web设计和用户界面元素添加到使用哪个HTML5开发的application中
# 在自定义的CSS中，使用 @import "Bootstrap"; 来导入 
gem 'bootstrap-sass', '2.0.4'  

# 使用Hash函数bcrypt对密码进行不可逆的加密，来得到密码的Hash值
gem 'bcrypt-ruby', '3.0.1'  

# 可提供自动处理数据库迁移等操作
#（如果把Heroku当做实际生产环境）
gem 'kumade'

# 可通过Rake任务来创建示例用户
#（即：自动生成大量的user用户，而不需要自己手动注册生成）
# 在数据库中生成示例用户的Rake任务
# 这个Rake任务保存在'lib/tasks'中（创建'sample_data.rake'文件）
gem 'faker', '1.0.1'

# 实现分页功能
gem 'will_paginate', '3.0.3'
# 设置'will_paginate'使用'bootstrap'中的分页样式
gem 'bootstrap-will_paginate', '0.0.6'


group :development, :test do
	gem 'sqlite3', '1.3.5'       # 'sqlite3'数据库
	gem 'rspec-rails', '2.11.0'  # 'RSpec'测试框架编写testcase
	gem 'guard-rspec', '1.2.1'   # 'guard'测试套件
	gem 'guard-spork', '1.2.0'   # ’Spork‘加速测试的gem
	gem 'spork', '0.9.2'         # ’Spork‘加速测试的gem

	# 注解套件（可以自动设定在模型文件总加入一些注释）
	gem 'annotate', '2.5.0'  
	
	# 'RSpec'测试中使用的预构件
	#（创建模型，生成ActiveRecord对象，取代model中的User.create方法）
	gem 'factory_girl_rails', '4.1.0' 
end

group :assets do
  gem 'sass-rails',   '3.2.5'  # 程序的资源文件（css、javascript、img）
  gem 'coffee-rails', '3.2.2'
  gem 'uglifier', '1.2.3'     # 在 asset pipeline 中处理文件的压缩
end

group :test do
	# ’Capybara‘允许使用类似英语中的句法来编写模拟与应用程序交互的代码（如：it语句、visit语句）
	# 与’RSpec‘测试套件一起使用的gem
	gem 'capybara', '1.1.2'    

	# 'Cucumber'支持行为驱动开发的自动化测试工具
	gem 'cucumber-rails', '1.2.1', require: false
	gem 'database_cleaner', '0.7.0'

	# 下面两个gem都是基于’guard‘测试套件所需的gem
	gem 'rb-fsevent', '0.9.1', :require => false 
	gem 'growl', '1.0.3'
end

group :production do   
	gem 'pg', '0.12.2'   # 'PostgreSQL'数据库
end


# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

# Gems used only for assets and not required
# in production environments by default.

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'
