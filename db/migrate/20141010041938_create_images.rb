class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :name
      t.string :tag
      t.string :url
      t.integer :ownerId
      t.boolean :isTrash
      t.string :appliedFilters
      t.integer :lastVersion

      t.timestamps
    end
  end
end
