class Choice < ActiveRecord::Base
  attr_accessible :description, :survey_id, :value, :group_id

  belongs_to :question
end
