class Survey < ActiveRecord::Base
  attr_accessible :title, :questions_attributes, :description
  has_many :questions
  has_many :user_surveys
  accepts_nested_attributes_for :questions, :allow_destroy => true
end
