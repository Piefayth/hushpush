module WidgetsHelper

	def widget_types
		return ['Clock', 'Weather', 'RSS', 'ToDo', 'Gmail']
	end

	def widget_exists?(widget)
		widget_types.include? widget
	end

	def default_properties
		{}
	end

	def get_forecast_weather(widget)
		unless Rails.cache.fetch("fweather#{widget.widget_preference.weather_city.downcase}#{widget.widget_preference.weather_state.downcase}").nil?
			return Rails.cache.fetch("fweather#{widget.widget_preference.weather_city.downcase}#{widget.widget_preference.weather_state.downcase}")
		else
			require 'net/http'
			city = widget.widget_preference.weather_city
			state = widget.widget_preference.weather_state
			begin
				url = URI.parse("http://api.openweathermap.org/data/2.5/forecast?q=#{city},#{state}&cnt=1&units=imperial&mode=json&APPID=0a0cb68421eaf931257479eaf5a8a29c".to_s.gsub(/\s+/, ""))
				res = Net::HTTP.get_response(url)
				unless res.nil?
					Rails.cache.write("fweather#{widget.widget_preference.weather_city.downcase}#{widget.widget_preference.weather_state.downcase}", res.body, expires_in: 10.minutes)
					return res.body
				else
					return nil
				end
			rescue
				return nil
			end
		end
	end

	def get_rss_feed(widget)
		unless Rails.cache.fetch("feed#{widget.widget_preference.rss_feed}").nil?
			feed = Rails.cache.fetch("feed#{widget.widget_preference.rss_feed}")
			title = feed[0]
			pages = WillPaginate::Collection.create(get_rss_page(widget), 5, feed[1].entries.first(30).count) do |pager|
				pager.replace feed[1].entries[pager.offset, pager.per_page].to_a
			end
			return title, pages
		else
			begin
				feed = Feedzirra::Feed.fetch_and_parse(widget.widget_preference.rss_feed)
				title = feed.title
				unless feed.blank?
					pages = WillPaginate::Collection.create(get_rss_page(widget), 5, feed.entries.first(30).count) do |pager|
						pager.replace feed.entries[pager.offset, pager.per_page].to_a
					end
					Rails.cache.write("feed#{widget.widget_preference.rss_feed}", [title, feed], expires_in: 10.minutes)
					return title, pages
				else
					return nil
				end
			rescue
				return nil
			end
		end
	end

	def get_rss_page(widget)
		unless Rails.cache.fetch("feed#{widget.id}").nil?
			Rails.cache.fetch("feed#{widget.id}")
		else
			1
		end
	end
end


