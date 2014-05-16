class AddAdminToUsers < ActiveRecord::Migration

  def change
  	# 添加'admin'默认值为'false'，表示：用户默认不是管理员
    add_column :users, :admin, :boolean, default: false
  end
end
