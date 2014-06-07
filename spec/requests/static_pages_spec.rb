#【静态页面测试】

# 1.验证相应标记中的文本内容
# 2.验证链接是否指向正确的页面

# 【首页的微博验证】
# 3.验证首页是否显示当前用户的微博列表
# 4.验证侧边栏中微博数量是否正确显示
#   1) 两条微博时，显示'2 microposts'
#   2) 一条微博时，显示'1 micropost'
# 5.验证微博的分页功能（默认一页30条记录）
#   1）验证分页标签是否存在
#   2）验证第一页的30条微博内容是否正确

#【首页关注验证】
# 6.验证首页'被关注用户'和'粉丝'的数量是否正确



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

	# 1.验证相应标记中的文本内容
	describe "Help page" do
		before { visit help_path }

 		# 验证title和h1标记中的内容
		# 设置共享模块中参数的Hash值
		# 调用共享模块中的验证方法	
		let(:header){ 'Help' }
		let(:page_title){ 'Help' }
		it_should_behave_like "all_static_pages"
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

	# 2.验证链接是否指向了正确的页面
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

	describe "Home page" do

		before { visit root_path } 
	
		let(:header) { 'Welcome to the Sample' }
		let(:page_title) { '' }
		it_should_behave_like "all_static_pages"

		# 验证title标记中的内容是否没有出现‘| Home’
		it { should_not have_selector('title', text: '| Home') }

		#【首页的微博验证】
		# 3.验证首页是否显示当前用户的微博列表
		# 4.验证侧边栏中微博数量是否正确显示
		describe "for signed-in users" do

			let(:user) { FactoryGirl.create(:user) }
			before(:each) do
				FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
				FactoryGirl.create(:micropost, user: user, content: "Dolor sit amet")
				sign_in user
				visit root_path
			end

			# 3.验证首页是否显示当前用户的微博列表
			it "should render the user's feed" do
				user.feed.each do |item|
					should have_selector("li##{item.id}", text: item.content)
				end
			end

			# 4.验证侧边栏中微博数量是否正确显示
			#   1) 两条微博时，显示'2 microposts'
			#   2) 一条微博时，显示'1 micropost'
			it "two microposts" do
				should have_content("2 microposts") 
			end

			describe "one micropost" do
				before { click_link "delete" }
				it { should have_content("1 micropost") }
			end
		end

		#【首页微博验证】
		# 5.验证微博的分页功能（默认一页30条记录）
		#   1）验证分页标签是否存在
		#   2）验证第一页的30条微博内容是否正确
		describe "microposts paginate" do

			let(:user) { FactoryGirl.create(:user) }

			before do 
				31.times{ FactoryGirl.create(:micropost, user: user) } 
				sign_in user
				visit root_path
			end

			after(:all) { Micropost.delete_all }

			it { should have_selector('div.pagination') }
			
			it "should list each micropost" do
				Micropost.paginate(page: 1).each do |micropost|
					should have_selector('li', text: micropost.content )
				end
			end 
		end
	end

	#【首页关注验证】
	# 6.验证首页'被关注用户'和'粉丝'的数量是否正确
	describe "following/followers counts" do

		let(:user){ FactoryGirl.create(:user) }
		let(:other_user){ FactoryGirl.create(:user) }
		
		before do
			other_user.follow!(user)
			sign_in user
			visit root_path
		end

		it { should have_link('0 following', href: following_user_path(user)) }
		it { should have_link('1 followers', href: followers_user_path(user)) }

	end


end
