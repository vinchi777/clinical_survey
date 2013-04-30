# encoding: utf-8
class HomeController < ApplicationController
  before_filter :authenticate_user!
  def index
    user_survey = User.find(current_user.id).user_surveys
    @user_surveys = user_survey.paginate(:per_page => 12, :page => params[:page], :order => 'starting_date DESC')
    if params[:sort]
      if session[:order].eql?"ASC"
        order = session[:order] = "DESC"
      else
        order = session[:order] = "ASC"
      end
    else
      order = 'ASC'
      session[:order] = 'ASC'
    end
    @symbol = (order.eql?"ASC")? "↑" : "↓"
    @schedules = user_survey.paginate(:conditions => ['next_schedule > ?', Time.now.to_date], :per_page => 10, :page => params[:schedule_page], :order => "next_schedule #{order}")
    @overdue = user_survey.paginate(:conditions => ['starting_date < ? AND status != ?', Time.now.to_date, "Complete"], :per_page => 10, :page => params[:overdue_page])
    @today = user_survey.paginate(:conditions => ['starting_date = ?', Time.now.to_date], :per_page => 10, :page => params[:todays_page])
  end
end
