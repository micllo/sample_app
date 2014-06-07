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


class Relationship < ActiveRecord::Base
  attr_accessible :followed_id

  # 验证follower_id不能缺省
  # 验证followed_id不能缺省
  validates :follower_id, presence: true
  validates :followed_id, presence: true


  #【关联】将User用户对象关联Follower对象
  # 	  将'relationship'中的'follower_id'作为外键，关联'User'中的'id'
  # (注：Rails会根据类名'Follower'自动去匹配'Relationship/follower_id'与'Follower/id'
  #      但找不到'Follower'这个类，所以需要手动进行匹配)
  # relationship.follower   (返回粉丝对象)
  # relationship.followed   (返回被关注的对象)
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"


end
