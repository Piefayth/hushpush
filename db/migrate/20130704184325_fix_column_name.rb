class FixColumnName < ActiveRecord::Migration
  def up
  	rename_column :widgets, :type, :name
  end

  def down
  end
end
