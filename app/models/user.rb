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
# micropost.user               (返回该微博对应的用户对象)
# user.microposts             （返回该用户的所有微博数组）
# user.microposts.create(arg) （创建一篇微博 user_id = user.id）
# user.microposts.create!(arg)（创建一篇微博（失败时抛出异常））
# user.microposts.build(arg)   (生成一个新的微博对象 user_id = user.id)

# 用户相互关注的方法
# relationship.follower           (返回粉丝对象)
# relationship.followed           (返回被关注的对象)

# user.relationships              (返回被该用户关注的所有用户的followed_id数组)
# user.relationships.create(arg)  (创建一个用户关注 follower_id = user.id)
# user.relationships.create!(arg) (创建一个用户关注 （失败时抛出异常）)
# user.relationships.build(arg)   (创建一个新的用户关注对象 follower_id = user.id)
# user.followed_users             (返回被该用户关注的所有用户数组)

# user.reverse_relationships                (返回该用户的粉丝的follower_id数组)
# user.followers                            (返回该用户的粉丝数组)

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


  # 【关联】'User用户对象'与'Micropost对象' （可获得该用户所有的微博对象数组）
  # （将'User'类中的'id'属性与'Micropost'类中的'user_id'属性相关联）
  # （即：一个'user'对象可以有多个'micropost'对象）
  # 1.同步删除：设定程序在用户被删除的时候，同时删除其所属的微博
  # 2.绑定外键：'microposts'中'user_id'属性格式正好可以被Rails匹配为外键
  has_many :microposts, dependent: :destroy


  #【关联】'User用户对象'与'Relationship对象' （可获得被该用户关注的所有用户对象的followed_id数组）
  #      （将'User'类中的'id'属性与'Relationship'表中的'follower_id'属性相关联）
  # 1.同步删除：设定程序在删除用户的时候，同时删除其关注的所有用户对象数组
  # 2.绑定外键：'relationship'中没有'user_id'这个属性，需要手动匹配相应的外键
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy

  #【关联】'User用户对象'与'followed_users对象(虚拟表)' （可获得被该用户关注的所有用户对象的数组）
  # 参数1：使用自定义的'followed_users'虚拟表,取代Rails所认可的'followed'虚拟表
  # 参数2：通过指定已关联的':relationships'表，可以获取被关注用户的followed_id数组
  # 参数3：由于第一个参数设置的是自定义的虚拟表，所以需要指向Rails所认可的'followed'方法
  #       (注：Rails会把'followeds'转换成单数形式，告知Rails followed_users数组来源是followed所代表的id集合
  #        即：将'followed_users'虚拟表的'followed_id'作为外键与'relationship'表相关联）
  has_many :followed_users, through: :relationships, source: :followed

  #【关联】'User用户对象'与'Reverse_relationship对象' （可获得该用户的所有粉丝对象的follower_id数组）
  #      （将'User'类中的'id'属性与'Reverse_relationship'虚拟表中的'followed_id'属性相关联）
  # 1.同步删除：设定程序在删除用户的时候，同时删除其对应的所有粉丝数组
  # 2.绑定外键：'reverse_relationships'中没有'user_id'这个属性，需要手动匹配相应的外键
  # 3.创建虚拟表：通过反转'Relationship'表来创建一个虚拟的'reverse_relationship'表
  #             由于'reverse_relationship'表并不存在，所以需要指定相应的类名
  has_many :reverse_relationships, foreign_key: "followed_id", class_name: "Relationship", dependent: :destroy

  #【关联】'User用户对象'与'followers对象(虚拟表)' （可获得该用户的所有粉丝对象的数组）
  # 参数1：使用Rails认可的'followers'方法
  #       (注：Rails会把'followers'转换成单数形式，告知Rails followers数组来源是follower所代表的id集合
  #        即：将'followers'虚拟表的'follower_id'作为外键与'relationship'表相关联）
  # 参数2：通过指定已定义的':reverse_relationships'虚拟表，可以获取粉丝用户的follower_id数组
  # 参数3：由于参数1使用了Rails认可的方法，所以可以省略
  has_many :followers, through: :reverse_relationships, source: :follower


  # 创建用户的安全密码（用来验证用户身份的方法）
  # 对应数据模型中的‘password_digest’字段
  # 提供 authenticate 方法
  has_secure_password

  # 在email存入数据库之前，把email转换成小写
  #before_save { self.email.downcase! }
  before_save { |user| user.email = email.downcase }

  # 在user模型保存之前会调用create_remember_token方法来创建'remember_token'
  before_save :create_remember_token


  #【定义User模型自己的方法】
  # 调用Micropost模型的方法，来获取当前用户自己的微博和所关注用户的微博（即：动态列表）
  def feed
      Micropost.from_users_followed_by(self)

      # 获取当前用户自己的微博
      # '?'可以确保id的值在传入底层的SQL查询语句之前做了适当的转义，避免'SQL注入'的安全隐患
      # Micropost.where("user_id = ?", id)
  end

  # 判断是否关注了这个用户
  def following?(other_user)
      relationships.find_by_followed_id(other_user)
  end

  # 关注用户的操作 ('!'表示捕获异常)
  def follow!(other_user)
      relationships.create!(followed_id: other_user.id)
  end

  # 取消用户关注的操作
  def unfollow!(other_user)
      relationships.find_by_followed_id(other_user).destroy
  end


  private
    def create_remember_token
        # 调用Ruby标准库中SecureRandom模块提供的urlsafe_base64方法来生成随机的字符串
        self.remember_token = SecureRandom.urlsafe_base64
    end
end








