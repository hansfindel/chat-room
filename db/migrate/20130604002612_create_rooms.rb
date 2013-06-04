class CreateRooms < ActiveRecord::Migration
  def change
    create_table :rooms do |t|
      t.string :name
      t.string :topic
      t.string :user_id

      t.timestamps
    end
  end
end
