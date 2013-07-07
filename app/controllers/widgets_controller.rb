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

		@widget.properties = params.except(:utf8, :_method, :authenticity_token, :commit, :action, :controller, :id).as_json
		@widget.save
		redirect_to root_url
	end		

	def page
		set_rss_page(Widget.find(params[:id]), params[:page])
		redirect_to root_url
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
