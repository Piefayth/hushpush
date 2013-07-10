class CreateWidgetPreferences < ActiveRecord::Migration
   def change
       create_table :widget_preferences do |t|
			t.string :background_color
			t.text :todo_tasks
			t.string :weather_city
			t.string :weather_state
			t.string :rss_feed
			t.string :gmail_access_token
			t.string :gmail_address
			t.string :gmail_refresh_token
			t.string :gmail_expires_in
			t.integer :widget_id
  	   end
  	   add_index :widget_preferences, :widget_id
   end
end
