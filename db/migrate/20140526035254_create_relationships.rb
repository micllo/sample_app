class CreateRelationships < ActiveRecord::Migration
  def change
    create_table :relationships do |t|
      t.integer :follower_id
      t.integer :followed_id

      t.timestamps
    end

    # 增加索引来提高数据查找的性能
    add_index :relationships, :follower_id
    add_index :relationships, :followed_id

    # 增加了组合索引，目的是确保用户不可以多次关注同一个用户
    add_index :relationships, [:follower_id, :followed_id], unique: true
  end
end
