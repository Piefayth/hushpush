class CreateWidgets < ActiveRecord::Migration
  def change
    create_table :widgets do |t|
      t.string :type
      t.integer :user_id
      t.text :properties

      t.timestamps
    end
    add_index :widgets, :user_id
  end
end
