task :create_surveys => :environment do
  user_surveys = UserSurvey.all
  user_surveys.each do |user_survey|
    if user_survey.next_schedule.to_s.eql? Time.now.to_date.to_s
      if user_survey.schedule.eql?"weekly"
        next_schedule = 1.week
      elsif
        next_schedule = 1.month
      end
      schedule = (user_survey.next_schedule + next_schedule)
      user_survey.create_ccq(schedule)
    end
  end
  User.all.each do |u|
    user_survey = u.user_surveys.today
    if user_survey.count != 0
      ResultsMailer.schedule_email(u).deliver
    end
  end
end
