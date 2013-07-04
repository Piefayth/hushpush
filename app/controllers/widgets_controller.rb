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
		@widget.destroy
		redirect_to root_url
	end
end
