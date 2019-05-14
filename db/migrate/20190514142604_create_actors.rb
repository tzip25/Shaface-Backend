class CreateActors < ActiveRecord::Migration[5.2]
  def change
    create_table :actors do |t|
      t.string :first_name
      t.string :last_name
      t.string :birthday
      t.string :img_url
      t.string :imdb_id

      t.timestamps
    end
  end
end
