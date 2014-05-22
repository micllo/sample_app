#【静态页面测试】

# 1.验证路由设置
# 2.验证相应标记中的文本内容
# 3.验证链接是否指向正确的页面

# 验证首页是否显示当前用户的微博列表

require 'spec_helper'

describe "Static pages" do	
	# 将page设置为默认的测试对象 -- ‘it’代码块会默认调用它
	subject { page }

	# 将所有相同的验证方法存放入共享模块中
	# 验证标记内容
	shared_examples_for "all_static_pages" do
		it { should have_selector('h1', text: header) }
		it { should have_selector('title', text: full_title(page_title)) }
	end

	describe "Home page" do

		# 会先于it执行，‘it’代码块会默认调用它（针对路由设置的测试）
		before { visit root_path } 

 		# 验证title和h1标记中的内容
		# 设置共享模块中参数的Hash值
		# 调用共享模块中的验证方法		
		let(:header) { 'Welcome to the Sample' }
		let(:page_title) { '' }
		it_should_behave_like "all_static_pages"

		# 验证title标记中的内容是否没有出现‘| Home’
		it { should_not have_selector('title', text: '| Home') }


		# 验证首页是否显示当前用户的微博列表
		describe "for signed-in users" do

			let(:user) { FactoryGirl.create(:user) }
			before do
				FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
				FactoryGirl.create(:micropost, user: user, content: "Dolor sit amet")
				sign_in user
				visit root_path
			end

			it "should render the user's feed" do
				user.feed.each do |item|
					should have_selector("li##{item.id}", text: item.content)
				end
			end
		end
	end


	describe "Help page" do
		before { visit help_path }

		let(:header){ 'Help' }
		let(:page_title){ 'Help' }
		it_should_behave_like "all_static_pages"
=begin

		it { should have_selector('h1', text: "Help") }
		it { should have_selector('title', text: full_title('Help')) }
=end
	end

	describe "About page" do
		before { visit about_path }

		let(:header){ 'About Us' }
		let(:page_title){ 'About Us' }
		it_should_behave_like "all_static_pages"
	end

	describe "Contact page" do
		before { visit contact_path }

		let(:header){ 'Contact' }
		let(:page_title){ 'Contact' }
		it_should_behave_like "all_static_pages"
	end

	# 3.验证链接是否指向了正确的页面
	it "should have the right links to the layout" do
		# 访问首页
		visit root_path

		# 点击 About 链接（进入about页面进行验证）
		click_link "About"
		page.should have_selector('title', text: "About Us")

		click_link "Help"
		page.should have_selector('title', text: "Help")

		click_link "Contact"
		page.should have_selector('title', text: "Contact")

		click_link "Home"

		click_link "Sign up now !"
		page.should have_selector('title', text: "Sign up")

		click_link "Home"
		page.should have_selector('title', text: "Ruby on Rails Tutorial Sample App")

	end
end
