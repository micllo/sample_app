# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  email           :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  password_digest :string(255)
#  remember_token  :string(255)
#  admin           :boolean          default(FALSE)
#

#【数据模型测试】

# 1.验证user数据模型中是否存在相应的属性（存在性验证）

# 2.验证各属性的合法操作（有效性验证）

# 3.验证'admin'属性
#   1)'admin'属性是无效的
#   2)将'admin'属性设置为有效

# 4.验证各属性的非法操作（无效性验证）
# 	1）name为空
# 	2）email为空
# 	3）name的长度验证（假设长度限制为50个字符）（长度验证）
# 	4）email无效的格式验证（格式验证）
# 	5）email有效的格式验证（格式验证）
# 	6）email的唯一性验证（唯一性验证）
#  	 （1）相同的email地址是不能注册的 并且不区分大小写（即：仅大小写不同等于相同））
#    （2）防止连续重复的提交，导致相同的email地址被注册两次的情况：
#        1）需要在数据层添加一个唯一性的索引
#        2）需要在email存入数据库之前，把email转换成小写
# 	7）password为空
# 	8）password和password_confirmation不一致
# 	9）password长度不能小于6位数
# 	10）验证记忆权标是否会自动创建

# 5.用户身份的验证（通过email和password来取回用户对象）
#   1）先将user信息插入数据库中
#   2）用'email'找到数据库中的user信息
#   3）用'password'去比较找到的user信息中的密码


# 用户身份验证：【数据层】
# 目的：就是为了规避安全隐患，因为数据库中存入的密码是经过加密处理的（使得任何人都无法识别）
# 方法：调用'has_secure_password'中的'authenticate'方法，传入用户提交的密码作为参数，
#      先进行加密处理，然后再将其与数据库中存储的加密密码进行对比
# 注意：数据库中添加的’password_digest‘字段，就代替了‘password’和‘password_confirmation’这两个字段




require 'spec_helper'

describe "User" do

	# 先于it执行
	before do
		@user = User.new(name: "micllo",
						 email: "micllo@126.com",
						 password: "foobar",
						 password_confirmation: "foobar") 
	end

	# 将user模型设置为默认的测试对象
	subject { @user }

	# 1.验证user数据模型中是否存在相应的属性（存在性验证）
	# ‘authenticate’方法是否存在
	it { should respond_to(:name) }
	it { should respond_to(:email) }
	it { should respond_to(:password_digest) }
	it { should respond_to(:password) }
	it { should respond_to(:password_confirmation) }
	it { should respond_to(:remember_token) }
	it { should respond_to(:authenticate) } 
	it { should respond_to(:admin) }


	# 验证admin属性是不可访问的



	# 2.验证各属性的合法操作（有效性验证）
	it { should be_valid }

	# 3.验证'admin'属性
	#   1)'admin'属性是无效的
	#   2)将'admin'属性设置为有效
	it { should_not be_admin }
	describe "with admin attribute set to true" do
		before { @user.toggle!(:admin) }
		it { should be_admin }
	end


	# 4.验证各属性的非法操作（无效性验证）
	# 	1）name为空
	# 	2）email为空
	# 	3）name的长度验证（假设长度限制为50个字符）（长度验证）
	# 	4）email无效的格式验证（格式验证）
	# 	5）email有效的格式验证（格式验证）
	# 	6）email的唯一性验证（唯一性验证）
	#  	 （1）相同的email地址是不能注册的 并且不区分大小写（即：仅大小写不同等于相同））
	#    （2）防止连续重复的提交，导致相同的email地址被注册两次的情况：
	#        1）需要在数据层添加一个唯一性的索引
	#        2）需要在email存入数据库之前，把email转换成小写
	# 	7）password为空
	# 	8）password和password_confirmation不一致
	# 	9）password长度不能小于6位数
	describe "when name is not present" do
		before { @user.name = "" }
		it { should_not be_valid }
	end

	describe "when email is not present" do
		before { @user.email = "" }
		it { should_not be_valid }
	end

	describe "when name is too long" do
		before { @user.name = "a" * 51 }
		it { should_not be_valid }
	end

	describe "when email format is invalid" do
		it "should be invalid" do
			addresses = %w[user@foo,com user_at_foo.org example.user@foo.foo@bar_baz.com foo@bar+baz.com]
			addresses.each do |invalid_address| 
				@user.email = invalid_address 
				@user.should_not be_valid
		    end 
		end
	end

	describe "when email format is valid" do 
		it "should be valid" do
			addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn] 
			addresses.each do |valid_address|
				@user.email = valid_address
				@user.should be_valid 
			end
		end 
	end

	describe "when email address is already taken" do
		before do
			# 'dup'创建一个与user Email地址一样的用户对象
			user_with_same_email = @user.dup
			user_with_same_email.email = @user.email.upcase
			user_with_same_email.save
		end

		it { should_not be_valid }
	end

	describe "when password is not present" do
		before { @user.password = @user.password_confirmation = " " }
		it { should_not be_valid }
	end

	describe "when password doesn't match passwor_confirmation" do
		before { @user.password_confirmation = "mismatch" }
		it { should_not be_valid }
	end

=begin
	# 验证 password_confirmation 的值不能是nil(该情况很少会出现)
	#（原因：如果确认密码的值是nil的话，rails将不会进行一致性验证）
	describe "when password confirmation is nil" do
		before { @user.password_confirmation = nil }
		it { should_not be_valid }
	end
=end

	describe "with a password that's too short" do
		before { @user.password = @user.password_confirmation = "a" * 5 }
		it { should be_invalid }
	end


	#【验证记忆权标是否会自动创建】
	describe "remember token" do

		before { @user.save }

		# 仅验证'remember_token'属性是否为非空
		its(:remember_token){ should_not be_blank }
	end


	# 5.用户身份的验证（通过email和password来取回用户对象）
	#   1）先将user信息插入数据库中
	#   2）用'email'找到数据库中的user信息
	#   3）用'password'去比较找到的user信息中的密码
	#  (注：password比较的是被加密后的安全密码【解释如下】)
	describe "return value of authenticate method" do

		before { @user.save }

		let(:found_user) { User.find_by_email(@user.email) }

		describe "with valid password" do
			# 调用'has_secure_password'中的'authenticate'方法
			# 1.将需要验证的password作为参数传进去
			# 2.‘authenticate’会将该password进行加密处理，
			# 3.然后再将其与找到的user中的加密密码进行对比
			# 4.如果参数正确，则返回user用户对象
			# 5.如果参数不正确，则返回false
			it { should == found_user.authenticate(@user.password) }
		end

		describe "with invalid password" do
			let(:user_for_invalid_password) { found_user.authenticate("invalid") }
			it { should_not == user_for_invalid_password }
			specify { user_for_invalid_password.should be_false }
		end
	end

end
