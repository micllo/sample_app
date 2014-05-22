# == Schema Information
#
# Table name: microposts
#
#  id         :integer          not null, primary key
#  content    :string(255)
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

#【'micropost'数据模型测试】

#.1.验证各个属性是否存在（存在性验证）
# 2.验证各属性的输入值是否合法（有效性验证）
# 3,验证使用'micropost'中的'user_id'属性创建微博时，是否会抛出异常
# 4.验证各属性的非法操作（无效性验证）


require 'spec_helper'

describe "Micropost" do

	let(:user) { FactoryGirl.create(:user) }

	# 将user模型和micropost模型关联起来(通过用户对象来创建微博)
	before { @micropost = user.microposts.build(content: "Lorem ipsum") }

	subject { @micropost }

	# 1.验证各个属性是否存在（存在性验证）
	it { should respond_to(:content) }
	it { should respond_to(:user_id) }
	# 测试微博对象是否可以响应用户方法
	it { should respond_to(:user) }
	its(:user) { should == user }
  
	# 2.验证各属性的输入值是否合法（有效性验证）
	it { should be_valid }


	# 3.验证使用'micropost'中的'user_id'属性创建微博时，是否会抛出异常
    #（由于安全起见'micropost'中的'user_id'属性设为不可访问）
	describe "accessible attributes" do
		it "should not allow access to user_id" do
			expect do
				Micropost.new(user_id: user.id)
			end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
		end
	end

	# 4.验证各属性的非法操作（无效性验证）
	#   1）用户ID不能为空
	#   2）微博内容不能为空
	#   3）微博长度不能超过140个字符（长度验证）
	describe "when user_id is not present" do
	   before { @micropost.user_id = nil }
	   it { should_not be_valid }
	end

	describe "with blank content" do
		before { @micropost.content = " " }
		it  { should_not be_valid }
	end

	describe "with content that is too long" do
		before { @micropost.content = "a" * 141 }
		it  { should_not be_valid }
	end









end
