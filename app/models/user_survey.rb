class UserSurvey < ActiveRecord::Base
  attr_accessible :schedule, :status, :survey_id, :user_id, :language, :next_schedule, :starting_date, :user_survey_no, :version, :schedule
  belongs_to :user
  belongs_to :survey
  has_many :answers
  scope :today, lambda { where("DATE(created_at) = '#{Date.today.to_s(:db)}'")}
  def set_status(status)
    self.update_attribute(:status, (status==10)?"Complete":(status>0)?"Incomplete":"Untaken")
  end
  def self.get_current_user_surveys(user_id)
    UserSurvey.where('user_id =? AND status =?',user_id,'Complete').order("starting_date DESC")
  end
  def create_ccq(schedule)
    user_survey = UserSurvey.create(:user_id => self.user_id, :survey_id => self.survey_id, :starting_date => self.next_schedule,
                :next_schedule => schedule,
                :schedule => self.schedule, :status => "Untaken", :language => self.language, :version => self.version)
    Question.by_survey_id(self.survey_id).count.times do |x|
      user_survey.answers.create(:question_id => x+1)
    end

  end
end
