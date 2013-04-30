class SurveysController < ApplicationController
  before_filter :authenticate_user!
  def index
    if params[:language] && params[:version]
      redirect_to new_user_survey_path(:survey_id => params[:survey_id],
                                         :locale => params[:language],
                                         :version => params[:version] )
    else
      redirect_to new_user_survey_path(:survey_id => Survey.first.id, :version => "Week", :locale => 'en')
    end
  end
end
