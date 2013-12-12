class CreateUsersMarks < ActiveRecord::Migration
  def change
    create_table :users_marks do |t|
      t.integer :user_id
      t.integer :music_id
      t.integer :mark, default:0

      t.timestamps
    end
  end
end
