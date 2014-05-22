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

# 用户和微博关联后所得的方法有：
# micropost.user (返回该微博对应的用户对象)
# user.microposts （返回该用户的所有微博数组）
# user.microposts.create(arg) （创建一篇微博 user_id = user.id）
# user.microposts.create!(arg)（创建一篇微博（失败时抛出异常））
# user.microposts.build(arg)   (生成一个新的微博对象 user_id = user.id)


class User < ActiveRecord::Base

  # 可访问的属性
  attr_accessible :email, :name, :password, :password_confirmation

  # 验证name：不能缺省、长度限制50
  # 验证password：不能缺省、长度限制6
  # 验证email：不能缺省、格式限制、唯一性(不区分大小写)
  validates :name, presence: true, length: { maximum: 50 }
  validates :password, length: { minimum: 6 }
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, 
  					format: { with: VALID_EMAIL_REGEX }, 
  					uniqueness: { case_sensitive: false }
  # validates :password_confirmation, presence: true 
  # 注：为了使注册页面的报错提示信息显示的更合理
  # (即：将’Password_digest can't be blank‘改成’Password can't be blank‘
  # 则需要在’config/locales/en.yml‘中配置一下，、
  # 且还要将这里的密码不能为空的设置去掉以防重复显示


  # 1.【关联】User用户对象与Micropost微博对象
  #（即：一个'user'对象可以有多个'micropost'对象）
  # 2.设定程序在用户被删除的时候，同时删除其所属的微博
  has_many :microposts, dependent: :destroy

  # 创建用户的安全密码（用来验证用户身份的方法）
  # 对应数据模型中的‘password_digest’字段
  # 提供 authenticate 方法
  has_secure_password

  # 在email存入数据库之前，把email转换成小写
  #before_save { self.email.downcase! }
  before_save { |user| user.email = email.downcase }

  # 在user模型保存之前会调用create_remember_token方法来创建'remember_token'
  before_save :create_remember_token

  # 定义user模型自己的方法（获取当前用户的微博）
  # '?'可以确保id的值在传入底层的SQL查询语句之前做了适当的转义，避免'SQL注入'的安全隐患
  def feed
    Micropost.where("user_id = ?", id)
  end


  private
    def create_remember_token
      # 调用Ruby标准库中SecureRandom模块提供的urlsafe_base64方法来生成随机的字符串
      self.remember_token = SecureRandom.urlsafe_base64
    end
end
