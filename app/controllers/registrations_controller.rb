class RegistrationsController < Devise::RegistrationsController
  def after_sign_up_path_for(resource)
    @user = User.find(current_user.id)
    random_s = SecureRandom.hex(16)
    user_id = @user.id.to_s
    random_s = random_s.slice(0, random_s.length - user_id.length) + user_id
    @user.update_attribute(:results_token, random_s)
    return home_path
  end
end
