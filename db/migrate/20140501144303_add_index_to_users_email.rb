class AddIndexToUsersEmail < ActiveRecord::Migration

  #为user这个表的email字段添加一个唯一性的索引，使用 add_index 函数
  #注意：这里的表名是复数形式(users)，因为创建表后系统自动将其复数化了
  def change
  	add_index :users, :email, unique: true
  end
end
