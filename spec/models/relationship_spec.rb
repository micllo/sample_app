# == Schema Information
#
# Table name: relationships
#
#  id          :integer          not null, primary key
#  follower_id :integer
#  followed_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#


#【'relationship'数据模型测试】
# 1.测试微博对象是否可以响应用户方法('belong_to'关系)
# 2.验证各属性的输入值是否合法（有效性验证）
# 3.验证'follower_id'该属性是不可访问的（出于安全考虑）

require 'spec_helper'


describe "Relationship" do 

	let(:follower) { FactoryGirl.create(:user) }
	let(:followed) { FactoryGirl.create(:user) }
	let(:relationship) { follower.relationships.build(followed_id: followed.id) }

	subject { relationship }
	
	# 1.测试微博对象是否可以响应用户方法('belong_to'关系)
	it { should respond_to(:follower) }
	it { should respond_to(:followed) }
	its(:follower) { should == follower }
	its(:followed) { should == followed }

	# 2.验证各属性的输入值是否合法（有效性验证）
	it { should be_valid } 

	# 3.验证'follower_id'该属性是不可访问的（出于安全考虑）
	# 即：只能通过'user.relationships.build()'的方法来创建微博
	#    而直接使用'relationship'中的'follower_id'属性创建微博时，是否会抛出异常
	describe "accessible attributes" do
		it "should not allow access to the follower id" do
			expect do
				Relationship.new(follower_id: follower.id)
			end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
		end
	end

	# 4.验证各属性的非法操作（无效性验证）
	# 	1）follower_id不能为空
	# 	2）followed_id不能为空
	describe "when follower id is not present" do
		before { relationship.follower_id = nil }
		it  { should_not be_valid }
	end

	describe "when followed id is not present" do
		before { relationship.followed_id = nil }
		it  { should_not be_valid }
	end

	
end
