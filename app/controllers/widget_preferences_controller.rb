class WidgetPreferencesController < ApplicationController

	def create
	end

	def update
		@widget_preference = WidgetPreference.find(params[:id])
		@widget_preference.notes = params[:notes]
		@widget_preference.save
		redirect_to root_url
	end

end