class AddFilterIdToMyfilters < ActiveRecord::Migration
  def change
    add_column :myfilters, :filter_id, :integer
  end
end
