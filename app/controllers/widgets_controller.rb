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
		if params[:task_name].nil?
			params.except(:utf8, :_method, :authenticity_token, :commit, :action, :controller, :id).each do |key, value|
				@widget.widget_preference[key] = value
			end
		else
			if @widget.widget_preference.todo_tasks.blank?
				@widget.widget_preference.todo_tasks = Array.new
				@widget.widget_preference.todo_tasks.push([params[:task_id], params[:task_name], params[:due_date]])
			else
				@widget.widget_preference.todo_tasks.push([params[:task_id], params[:task_name], params[:due_date]])
			end
		end
		@widget.save
		redirect_to root_url
	end		

	def remtask
		@widget = Widget.find(params[:id])

		@widget.widget_preference.todo_tasks.each do |task|
			if task[0].eql?(params[:task_id])
				@widget.widget_preference.todo_tasks.delete(task)
			end
		end
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
			if @widget.widget_preference.gmail_refresh_token.blank?
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
					
					@widget.widget_preference.gmail_access_token = response["access_token"]
					@widget.widget_preference.gmail_refresh_token = response["refresh_token"]
					@widget.widget_preference.gmail_expires_in = response["expires_in"]
					
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
