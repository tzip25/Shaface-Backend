class AddTmdbIdToGenres < ActiveRecord::Migration[5.2]
  def change
    add_column :genres, :tmdb_id, :integer
  end
end
