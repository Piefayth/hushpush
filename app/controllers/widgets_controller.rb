class WidgetsController < ApplicationController
	before_filter :signed_in_user

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
end
