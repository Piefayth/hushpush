class WidgetPreference < ActiveRecord::Base
	belongs_to :widget
	serialize :todo_tasks
end