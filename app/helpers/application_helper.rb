module ApplicationHelper
  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def show_notice_alert(notice, alert)
    if notice
      content_tag(:p, "#{notice}", :class => 'info')
    elsif alert
      content_tag(:p, "#{alert}", :class => 'alert')
    end
  end

  def show_header
    content_tag :div, :class => 'header box', :id => 'user_nav' do
      content_tag(:a, 'Home', :href => root_path, :class => "left btn") +
      if user_signed_in?
        content_tag(:div, :class => 'right') do
          content_tag(:a, "Results", :href =>  results_path, :class => 'btn')+
          content_tag(:a, 'Settings', :href => edit_user_registration_path, :class => "btn") +
          content_tag(:a, "Sign out", :href =>  destroy_user_session_path, "data-method" => :delete, :rel => "nofollow", :class => 'btn')
        end +
        content_tag(:div, :class => 'clear right') do
          content_tag(:p, "Signed in as #{current_user.email}", :id => "current_user")
        end
      else
        content_tag(:div, :class => 'right') do
          content_tag(:a, 'Sign up', :href => new_user_registration_path, :class => "btn") +
          content_tag(:a, 'Sign in', :href => new_user_session_path, :class => "btn")
        end

      end
    end
  end

 def gender_select_options(selected)
   options_for_select([['Male', 'male'], ['Female', 'female']], selected)
 end

 def schedule_select_options(selected)
   options_for_select([['Weekly', 'weekly'], ['Monthly', 'monthly']], selected)
 end

 def notification_select_options(selected)
   options_for_select([['Email', 'email'], ['SMS', 'sms'], ['Both', 'both']], selected)
 end
end
