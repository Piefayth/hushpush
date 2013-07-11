class AddColumnToWidgetPreference < ActiveRecord::Migration
  def change
  	add_column :widget_preferences, :notes, :text
  end
end
