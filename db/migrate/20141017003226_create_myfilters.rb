class CreateMyfilters < ActiveRecord::Migration
  def change
    create_table :myfilters do |t|

      t.timestamps
    end
  end
end
