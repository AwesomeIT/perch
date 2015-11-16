class DashboardController < ApplicationController
	before_filter :authenticate_user!
  
	def welcome
	end

  def services_admin
  end
end
