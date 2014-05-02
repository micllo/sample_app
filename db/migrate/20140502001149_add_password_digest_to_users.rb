class AddPasswordDigestToUsers < ActiveRecord::Migration
  
  # wei user 这个表 添加一个字符串类型的列
  def change
    add_column :users, :password_digest, :string
  end
end
