class CreateShareinfos < ActiveRecord::Migration
  def change
    create_table :shareinfos do |t|
      t.string :useremail
      t.integer :imageid

      t.timestamps
    end
  end
end
