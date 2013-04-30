class ResultsMailer < ActionMailer::Base
  default :from => "admin@ccq.com"

  def results_email(user, doctors_email)
    @user = user
    mail(:to => doctors_email, :subject => "CCQ Results")
  end

  def schedule_email(user)
    @user = user
    @user_survey = @user.user_surveys.today
    mail(:to => @user.email, :subject => "New Surveys")
  end

end
