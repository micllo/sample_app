class CreateMicroposts < ActiveRecord::Migration
  def change
    create_table :microposts do |t|
      t.string :content
      t.integer :user_id

      t.timestamps
    end

    # 加入索引（即：要按照发布时间的倒序查询用户所有的微博）
    add_index :microposts, [:user_id, :created_at]
  end
end
