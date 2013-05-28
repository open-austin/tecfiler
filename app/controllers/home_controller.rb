class HomeController < ApplicationController
  
  # default home page
  def index
    @user = current_user
    if user_signed_in?
      @filer = @user.filer
      unless @filer.blank?
        @treasurer = @filer.treasurer 
        @reports = @filer.reports
      end
    end
  end
  
end
