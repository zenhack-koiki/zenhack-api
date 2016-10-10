class CreateImages < ActiveRecord::Migration[5.0]
  def change
    create_table :images do |t|
      t.string :url
      t.float :latitude
      t.float :longitude
      t.string :name
      t.string :state
      t.string :city
      t.string :zipcode

      t.timestamps
    end
  end
end
