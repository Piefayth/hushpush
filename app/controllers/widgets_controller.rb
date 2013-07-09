class WidgetsController < ApplicationController
	before_filter :signed_in_user
	before_filter :correct_user, only: [:destroy, :update]

	def create
		@widget = current_user.widgets.build(params[:widget])
		if @widget.save
			flash[:success] = "Widget added!"
			redirect_to root_url
		else
			flash[:error] = @widget.errors.full_messages
			redirect_to root_url
		end
	end

	def destroy
		@widget = Widget.find(params[:id])
		unless @widget.blank?
			@widget.destroy
		end
		redirect_to root_url
	end

	def update
		@widget = Widget.find(params[:id])
		temp_properties = @widget.properties
		@widget.properties = params.except(:utf8, :_method, :authenticity_token, :commit, :action, :controller, :id)
		unless temp_properties.eql?("{}")
			temp_properties.each do |key, value|
				if @widget.properties[key].nil?
					@widget.properties[key] = value
				end
			end
		end
		@widget.properties = @widget.properties.as_json
		@widget.save
		redirect_to root_url
	end		

	def load
		@widget = (Widget.find(params[:id]))
		respond_to do |format|
			format.html{ redirect_to root_url }
			format.js
		end
	end

	def page
		@widget = Widget.find(params[:id])
		set_rss_page(@widget, params[:page])
		respond_to do |format|
			format.html{ redirect_to root_url }
			format.js
		end
	end

	def oauthcallback
		require "uri"
		require "net/http"

		#Handle Gmail OAuth
		
		if params[:state].include?("gmail")
			state = params[:state].split("+")
			@widget = Widget.find(state[0])
			if @widget.properties["gmail_refresh_token"].blank?
				if params[:code].include?("error")
					flash[:error] = params[:code]
					redirect_to root_url
				else
					url = URI.parse('https://accounts.google.com/o/oauth2/token')
					request = Net::HTTP::Post.new(url.request_uri)
					request.set_form_data({code: params[:code], client_id: '948359240643.apps.googleusercontent.com',
														client_secret: 'KlDdcCN1lnetPu2eL1fzI3rf', redirect_uri: root_url + 'oauth2callback',
														grant_type: 'authorization_code'})
					response = Net::HTTP.start(url.host, use_ssl: true) do |http| http.request(request) end
					response = JSON.parse(response.body)
					

					temp_properties = @widget.properties.eql?("{}") ? JSON.parse(@widget.properties) : Hash.new

					temp_properties[:gmail_access_token] = response["access_token"] unless response["access_token"].nil?
					temp_properties[:gmail_refresh_token] = response["refresh_token"] unless response["access_token"].nil?
					temp_properties[:gmail_expires_in] = response["expires_in"] unless response["access_token"].nil?

					@widget.properties = temp_properties.as_json
					@widget.save
					redirect_to root_url
				end
			else
				redirect_to root_url
			end
		end

		#End Handle Gmail Oauth

	end

	private

		def correct_user
			@widget = current_user.widgets.find_by_id(params[:id])
			redirect_to root_url if @widget.nil?
		end

		def set_rss_page(widget, page)
			Rails.cache.write("feed#{widget.id}", page, expires_in: 10.minutes)
		end
end
