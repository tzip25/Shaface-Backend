class CreateActorMovies < ActiveRecord::Migration[5.2]
  def change
    create_table :actor_movies do |t|
      t.integer :actor_id
      t.integer :movie_id

      t.timestamps
    end
  end
end
