class RemoveLastNameFromActors < ActiveRecord::Migration[5.2]
  def change
    remove_column :actors, :last_name, :string
    remove_column :actors, :first_name, :string
    add_column :actors, :name, :string
    add_column :actors, :deathday, :string
    add_column :actors, :biography, :text
    add_column :actors, :place_of_birth, :string
  end
end
