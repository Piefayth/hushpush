module WidgetsHelper

	def widget_types
		return ['Clock', 'Weather', 'RSS', 'ToDo', 'Email', 'Calendar', 'Facebook', 'Twitter']
	end

	def widget_exists?(widget)
		widget_types.include? widget
	end

	def default_properties
		{}
	end

	def get_current_weather(widget)
		unless Rails.cache.fetch("weather#{widget.id}").nil?
			return Rails.cache.fetch("weather#{widget.id}")
		else
			require 'net/http'
			city = widget.properties["city"]
			country = widget.properties["country"]
			url = URI.parse("http://api.openweathermap.org/data/2.5/weather?q=#{city},#{country}&cnt=1&units=imperial&mode=json&APPID=0a0cb68421eaf931257479eaf5a8a29c".to_s)
			res = Net::HTTP.get_response(url)
			Rails.cache.write("weather#{widget.id}", res.body, expires_in: 10.minutes)
			return res.body
		end
	end

	def get_forecast_weather(widget)
		unless Rails.cache.fetch("fweather#{widget.id}").nil?
			return Rails.cache.fetch("fweather#{widget.id}")
		else
			require 'net/http'
			city = widget.properties["city"]
			country = widget.properties["country"]
			url = URI.parse("http://api.openweathermap.org/data/2.5/forecast?q=#{city},#{country}&cnt=1&units=imperial&mode=json&APPID=0a0cb68421eaf931257479eaf5a8a29c".to_s)
			res = Net::HTTP.get_response(url)
			Rails.cache.write("fweather#{widget.id}", res.body, expires_in: 60.minutes)
			return res.body
		end
	end
end
