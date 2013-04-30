class Answer < ActiveRecord::Base
  attr_accessible :pick, :question_id, :user_survey_id
  belongs_to :user_survey

end
