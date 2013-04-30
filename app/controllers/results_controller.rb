class ResultsController < ApplicationController
  before_filter :authenticate_user!, :only => [:index]

  def send_email
    ResultsMailer.results_email(current_user, params[:doctors_email]).deliver
    redirect_to root_path, :notice => "Results Sent!"
  end

  def retrieve
    @user = User.find_by_results_token(params[:token])
  end

  def show
    @user = User.find(params[:user])
    respond_to do |format|
      format.js {params[:id]}
      format.html
    end
  end
end
