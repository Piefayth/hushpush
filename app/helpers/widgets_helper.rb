module WidgetsHelper

	def widget_types
		return ['Clock', 'Weather', 'RSS']
	end

	def widget_exists?(widget)
		widget_types.include? widget
	end

	def default_properties
		{}
	end

end
