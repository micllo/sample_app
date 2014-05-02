# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ActiveRecord::Base
  # 可访问的属性
  attr_accessible :email, :name, :password, :password_confirmation

  #创建用户的安全密码（用来验证用户身份的方法，对应数据模型中的‘password_digest’字段）
  has_secure_password

  # 在email存入数据库之前，把email转换成小写
  before_save { |user| user.email = email.downcase }

  # 验证name：不能缺省、长度限制50
  validates :name, presence: true, length: { maximum: 50 }

  #验证email：不能缺省、格式限制、唯一性(不区分大小写)
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, 
  					format: { with: VALID_EMAIL_REGEX }, 
  					uniqueness: { case_sensitive: false }

  # 验证password：不能缺省、长度限制6
  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true
end
