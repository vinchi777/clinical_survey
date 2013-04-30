class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_locale

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options(options={})
      logger.debug "default_url_options is passed options: #{options.inspect}\n"
        { :locale => I18n.locale }
  end

  def after_sign_in_path_for(resource)
    return home_path
  end
end
