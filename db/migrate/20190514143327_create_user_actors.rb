class CreateUserActors < ActiveRecord::Migration[5.2]
  def change
    create_table :user_actors do |t|
      t.integer :user_id
      t.integer :actor_id

      t.timestamps
    end
  end
end
