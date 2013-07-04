class StaticPagesController < ApplicationController
  def home
  	@widget = current_user.widgets.build if signed_in?
  end

  def help
  end

  def about
  end

  def contact
  end
end
