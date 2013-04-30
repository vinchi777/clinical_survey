class User < ActiveRecord::Base
  has_many :user_surveys
  has_many :surveys, :through => :user_surveys
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name, :gender, :address, :phone, :schedule, :notification_method
  # attr_accessible :title, :body

  validates_presence_of :first_name, :last_name, :gender, :address, :phone, :schedule, :notification_method

end
