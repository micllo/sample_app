require 'spec_helper'

# 测试路由设置
# 测试相应标记中文本的验证
# 测试链接是否指向正确的页面

describe "Static pages" do	
	# 将page设置为默认的测试对象 -- ‘it’代码块会默认调用它
	subject { page }

	# 将所有相同的验证方法存放入共享模块中
	shared_examples_for "all_static_pages" do
		it { should have_selector('h1', text: header) }
		it { should have_selector('title', text: full_title(page_title)) }
	end

	describe "Home page" do
		# 会先于it执行，‘it’代码块会默认调用它（针对路由设置的测试）
		before { visit root_path }

		# 设置共享模块中参数的Hash值
		let(:header) { 'Welcomg to the Sample' }
		let(:page_title) { '' }

		# 调用共享模块中的验证方法（ 一个 it 代表一个 测试用例 ）
		it_should_behave_like "all_static_pages"

		# 验证title标记中的内容是否没有出现‘| Home’
		it { should_not have_selector('title', text: '| Home') }

=begin
		# 验证h1标记中的内容是否是‘Sample App’
		it { should have_selector('h1', text:'Welcomg to the Sample' ) }

		# 验证title标记中的内容是否为‘Ruby on Rails ...’
		it { should have_selector('title',text: full_title('')) }

		# 验证title标记中的内容是否没有出现‘| Home’
		it { should_not have_selector('title', text: '| Home') }


		# 简化之前的代码 -- 验证title标记
		it "shoud have the h1 'Welcomg to the Sample'" do
			visit root_path
			page.should have_selector('title', text: "Welcomg to the Sample")
		end
=end

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

	# 测试链接是否指向了正确的页面
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
