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
#

# 测试数据模型
# 存在性验证（属性赋值后是否存在）【表单层】
# 有效性验证（属性是否有效；如：不能为空）【表单层】
# 长度验证（name属性的长度限制）【表单层】
# 格式验证（email格式的验证）【表单层】
# 唯一性验证 
#（1）email注册时的唯一性【表单层】
#（2）防止连续重复的提交：
#    1）需要在数据层为email添加唯一性【数据层】的索引
#    2）在email存入数据库之前，把email转换成小写

# 用户身份验证：【数据层】
# 目的：就是为了规避安全隐患，因为数据库中存入的密码是经过加密处理的（使得任何人都无法识别）
# 方法：获取用户提交的密码，进行加密，再和数据库中存储的加密密码对比
# 注意：数据库中添加的’password_digest‘字段，就代替了‘password’和‘password_confirmation’这两个字段

require 'spec_helper'

describe User do
	# 先于it执行
	before do
		@user = User.new(name: "micllo",
						 email: "micllo@126.com",
						 password: "foobar",
						 password_confirmation: "foobar") 
	end

	# 将@user设置为默认的测试对象
	subject { @user }

	# 验证 user 数据模型中是否存在该字段（存在性验证）
	it { should respond_to(:name) }
	it { should respond_to(:email) }
	it { should respond_to(:password_digest) }
	it { should respond_to(:password) }
	it { should respond_to(:password_confirmation) }
	# 验证‘authenticate’方法是否存在
	# ‘authenticate’方法是用来验证用户密码的
	it { should respond_to(:authenticate) } 

	# 输入正确的字段后，是否能通过
	# 验证 user 的所有属性是否有效（有效性验证）
	it { should be_valid }


	# 验证当name属性为空时，是否会验证不通过（有效性验证）
	# 即：be_valid 应该要返回false 
	# 如果返回 false，则代表测试通过 

	# name 为空
	describe "when name is not present" do
		before { @user.name = "" }
		it { should_not be_valid }
	end

	# email 为空
	describe "when email is not present" do
		before { @user.email = "" }
		it { should_not be_valid }
	end


	# name的长度验证（假设长度限制为50个字符）（长度验证）
	describe "when name is too long" do
		before { @user.name = "a" * 51 }
		it { should_not be_valid }
	end


	# email无效的格式验证（格式验证）
	describe "when email format is invalid" do
		it "should be invalid" do
			addresses = %w[user@foo,com user_at_foo.org example.user@foo.foo@bar_baz.com foo@bar+baz.com]
			addresses.each do |invalid_address| 
				@user.email = invalid_address 
				@user.should_not be_valid
		    end 
		end
	end


	# email有效的格式验证（格式验证）
	describe "when email format is valid" do 
		it "should be valid" do
			addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn] 
			addresses.each do |valid_address|
				@user.email = valid_address
				@user.should be_valid 
			end
		end 
	end


	# email的唯一性验证（唯一性验证）

	#相同的email地址是不能注册的 并且不区分大小写（即：仅大小写不同等于相同）
	describe "when email address is already taken" do
		before do
			#创建一个与@user Email地址一样的用户对象
			user_with_same_email = @user.dup
			user_with_same_email.email = @user.email.upcase
			user_with_same_email.save
		end

		it { should_not be_valid }
	end

	#防止连续重复的提交，导致相同的email地址被注册两次的情况
	#需要在数据层添加一个唯一性的索引


	# password 为空
	describe "when password is not present" do
		before { @user.password = @user.password_confirmation = " " }
		it { should_not be_valid }
	end

	# password 和 password_confirmation 不一致
	describe "when password doesn't match passwor_confirmation" do
		before { @user.password_confirmation = "mismatch" }
		it { should_not be_valid }
	end

	# 验证 password_confirmation 的值不能是nil
	#（原因：如果确认密码的值是nil的话，rails将不会进行一致性验证）
	describe "when password confirmation is nil" do
		before { @user.password_confirmation = nil }
		it { should_not be_valid }
	end

	# password 长度不能小于6位数
	describe "with a password that's too short" do
		before { @user.password = @user.password_confirmation = "a" * 5 }
		it { should be_invalid }
	end

	# 【用户身份的验证】通过email和password来取回用户对象
	# 先将user信息插入数据库中
	# 用email,找到数据库中的user信息
	# 用password,将找到的信息与原来的信息进行比较
	describe "return value of authenticate method" do

		before { @user.save }

		# 用‘let’定义局部变量
		let(:found_user) { User.find_by_email(@user.email) }

		describe "with valid password" do
			# 调用'authenticate'方法，
			# 如果参数正确，则返回user用户对象
			# 如果参数不正确，则返回false
			it { should == found_user.authenticate(@user.password) }
		end

		describe "with invalid password" do
			let(:user_for_invalid_password) { found_user.authenticate("invalid") }
			it { should_not == user_for_invalid_password }
			specify { user_for_invalid_password.should be_false }
		end
	end




end
