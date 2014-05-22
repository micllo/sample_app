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

  #【关联】将User用户对象关与Micropost微博对象
  #（即：一个'micropost'对象只能属于一个'user'对象）
  belongs_to :user

  # 设定根据微博创建时间的倒序排列
  default_scope order: 'microposts.created_at DESC'

  # 验证user_id：不能缺省
  # 验证content：不能缺省，长度限制140
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
end
