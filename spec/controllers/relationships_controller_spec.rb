
#【控制器测试】
#（针对'elationship'控制器对'Ajax'请求的响应）

# 1.验证关注用户的Ajax操作
#   1）通过Ajax关注后，relationship表是否会增加一条记录
#   2）通过Ajax关注后，响应是否成功
# 2.验证取消关注的Ajax操作
#   1）通过Ajax取消关注后，relationship表是否会减少一条记录
#   2）通过Ajax取消关注后，响应是否成功


require 'spec_helper'

describe RelationshipsController do
	
	let(:user) 		 { FactoryGirl.create(:user) }
	let(:other_user) { FactoryGirl.create(:user) }

	before { sign_in user }

	# 1.验证关注用户的Ajax操作
	#   1）通过Ajax关注后，relationship表是否会增加一条记录
	#   2）通过Ajax关注后，响应是否成功
	describe "create a relationship with Ajax" do

		it "should increment the Relationship count" do
			# 'xhr'表示'XmlHttpRequest'
			# 通过xhr方法发送Ajax请求
			# 参数一：请求的方式
			# 参数二：action动作
			# 参数三：是一个Hash，代表controller中的params变量的值
			expect do
				xhr :post, :create, relationship: { followed_id: other_user.id }
			end.to change(Relationship, :count).by(1)
		end

		it "should response with success" do
			xhr :post, :create, relationship: { followed_id: other_user.id }
			expect(response).to be_success
		end
	end

	# 2.验证取消关注的Ajax操作
	#   1）通过Ajax取消关注后，relationship表是否会减少一条记录
	#   2）通过Ajax取消关注后，响应是否成功
	describe "destroy a relationship with Ajax" do

		before { user.follow!(other_user) }

		# 找到一组对应的关注关系记录
		let(:relationship) { user.relationships.find_by_followed_id(other_user) }

		it "should decrement the Relationship count" do
			# 'xhr'表示'XmlHttpRequest'
			# 通过xhr方法发送Ajax请求
			# 参数一：请求的方式
			# 参数二：action动作
			# 参数三：是一个Hash，代表controller中的params变量的值
			expect do
				xhr :delete, :destroy, id: relationship.id
			end.to change(Relationship, :count).by(-1)
		end

		it "should response with success" do
			xhr :delete, :destroy, id: relationship.id
			expect(response).to be_success
		end
	end

end


