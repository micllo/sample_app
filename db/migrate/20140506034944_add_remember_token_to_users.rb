class AddRememberTokenToUsers < ActiveRecord::Migration
  
  # 添加记忆权标属性
  # 为记忆权标属性添加索引（因为需要用记忆权标来取回用户）
  def change
  	add_column :users, :remember_token, :string
  	add_index :users, :remember_token
  end
end
