class Question < ActiveRecord::Base
  attr_accessible :survey_id, :title, :choices_attributes, :choice_group_id
  belongs_to :survey
  has_many :choices
  accepts_nested_attributes_for :choices, :allow_destroy => true
  scope :by_survey_id, lambda { |s_id| { :conditions => ['survey_id = ?', s_id] , :order => :choice_group_id} }
end
