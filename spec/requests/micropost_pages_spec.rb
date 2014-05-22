
#【发布微博功能验证】
# 1.验证发送失败后，数据库中的记录数量是否没有改变
# 2.验证发送失败后，是否会出现错误提示信息
# 3.验证发送成功后，数据库中的记录数量是否已改变

#【删除微博功能验证】
# 1.验证删除微博后，数据库中的微博数量是否已改变


require 'spec_helper'

describe "Micropost pages" do

	subject { page }

	let(:user) { FactoryGirl.create(:user) }
	before { sign_in user }

	#【发布微博功能验证】
	# 1.验证发送失败后，数据库中的记录数量是否没有改变
	# 2.验证发送失败后，是否会出现错误提示信息
	# 3.验证发送成功后，数据库中的记录数量是否已改变
	describe "micropost creation" do

		before { visit root_path }

		describe "with invalid information" do

			# 1.验证发送失败后，数据库中的记录数量是否没有改变
			it "should not create a micropost" do
				expect { click_button "Post"}.not_to change(Micropost, :count)
			end

			# 2.验证发送失败后，是否会出现错误提示信息
			describe "error messages" do
				before { click_button "Post" }
				it { should have_content('error') }
			end
		end 

		# 3.验证发送成功后，数据库中的记录数量是否已改变
		describe "with valid information" do

			before { fill_in 'micropost_content', with: "Lorem ipusm"}
			it "should create a micropost" do
				expect { click_button "Post" }.to change(Micropost, :count).by(1)
			end
		end 
	end

	#【删除微博功能验证】
	# 1.验证删除微博后，数据库中的微博数量是否已改变
	describe "micropost destruction" do

		before { FactoryGirl.create(:micropost, user: user) }

		describe "as correct user" do

			before { visit root_path }

			it "should delete a micropost" do
				expect { click_link "delete" }.to change(Micropost, :count).by(-1)
			end
		end
	end 




end
