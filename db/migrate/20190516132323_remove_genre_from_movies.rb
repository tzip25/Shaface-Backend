class RemoveGenreFromMovies < ActiveRecord::Migration[5.2]
  def change
    remove_column :movies, :genre, :string
    add_column :movies, :media_type, :string
    add_column :movies, :tmdb_id, :string
  end
end
