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

class Micropost < ActiveRecord::Base

  attr_accessible :content

  # 验证user_id：不能缺省
  # 验证content：不能缺省，长度限制140
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }

  #【关联】将User用户对象关联Micropost微博对象
  #      （即：一个'micropost'对象只能属于一个'user'对象）
  #       将'micropost'中的'user_id'作为外键，关联'User'中的'id'
  #       (注：Rails会根据类名'User'自动去匹配'Micropost/user_id'与'User/id')
  # micropost.user  (返回该微博对应的用户对象)
  belongs_to :user

  # 设定根据微博创建时间的倒序排列
  default_scope order: 'microposts.created_at DESC'


  # 提供自定义的方法
  # 获取自己的微博和自己所关注用户的微博
  # 1.获取该用户所关注用户的id集合
  # 2.通过SQL语句，查自己的微博和自己所关注用户的微博
  def self.from_users_followed_by(user)

    # 方法一：使用子查询
    # 1.变量'user_id'在查询中被用到了两次
    # 2.第二行调用了第一行的变量'followed_user_ids'，即：子查询
    # 3.完整的查询语句是：Micropost.where(...)
    followed_user_ids = "SELECT followed_id FROM relationships WHERE follower_id = :user_id"

    where("user_id = :user_id OR user_id IN (#{followed_user_ids})", user_id: user.id)


    # 方法二：该方法会导致一个问题（当关注用户超过5000时会影响性能）
=begin
    # 'user.followed_user_ids'方法是 ActionRecord 根据 has_many :followed_users关联合成的）
    # '?'可以确保id的值在传入底层的SQL查询语句之前做了适当的转义，避免'SQL注入'的安全隐患
    # 第二个参数'user'，Rails会自动获取它的user.id
    followed_user_ids = user.followed_user_ids
    where("user_id = ? OR user_id IN (?)", user, followed_user_ids)
=end

  end


end
