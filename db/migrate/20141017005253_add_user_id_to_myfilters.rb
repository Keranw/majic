class AddUserIdToMyfilters < ActiveRecord::Migration
  def change
    add_column :myfilters, :user_id, :integer
  end
end
