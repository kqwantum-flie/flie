class ApplicationController < ActionController::Base
  include Authentication
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  around_action :switch_locale

  def default_url_options
    { locale: I18n.locale }
  end

  # todo: add locale preference to user settings (none of that exists yet)
  # https://guides.rubyonrails.org/i18n.html#setting-the-locale-from-url-params
  def switch_locale(&action)
    # priority order:
    # param -> user preference setting -> default
    # locale = params[:locale] || current_user.try(:locale) || I18n.default_locale
    # uncomment the above line when user preferences are complete.
    # for now using this:
    locale = params[:locale] || I18n.default_locale
    I18n.with_locale(locale, &action)
  end

end
