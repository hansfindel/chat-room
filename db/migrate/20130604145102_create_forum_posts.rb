class CreateForumPosts < ActiveRecord::Migration
  def change
    create_table :forum_posts do |t|
      t.string :content
      t.integer :user_id
      t.integer :forum_id

      t.timestamps
    end
  end
end
