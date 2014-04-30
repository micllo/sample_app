require 'spec_helper'

describe "Static pages" do	
	# ‘it’代码块中会调用的page验证方法
	subject { page }

	describe "Home page" do
		# ‘it’代码块中会调用的访问路径
		before { visit root_path }

			# 验证h1标记中的内容是否是‘Sample App’
		it { should have_selector('h1', text:'Welcomg to the Sample' ) }

			# 验证title标记中的内容是否为‘Ruby on Rails ...’
		it { should have_selector('title',text: full_title('Home')) }

=begin
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

		it { should have_selector('h1', text: "Help") }
		it { should have_selector('title', text: full_title('Help')) }
	end

	describe "About page" do
		before { visit about_path }

		it { should have_selector('h1', text: "About Us") }
		it { should have_selector('title', text: full_title('About Us')) }
	end

	describe "Contact page" do
		before { visit contact_path }

		it { should have_selector('h1', text: "Contact") }
		it { should have_selector('title', text: full_title('Contact')) }
	end
end
