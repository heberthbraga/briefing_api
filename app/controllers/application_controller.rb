class ApplicationController < ActionController::API
  include Pundit::Authorization
  include SchemaValidable
  include ErrorRenderable
  include Renderable

  around_action :switch_locale

  before_action :authenticate_user!
  before_action :set_default_response_format

  respond_to? :json

  attr_reader :current_user

  private

  def authenticate_user!
    authorizer = V1::Security::Authorize.call(request.headers)

    @current_user = authorizer.result

    if @current_user.blank?
      Rails.logger.error("Authorization error: #{authorizer.errors}")
      raise Errors::Unauthorized
    end
  end

  def switch_locale(&action)
    locale = extract_locale_from_header || I18n.default_locale
    I18n.with_locale(locale, &action)
  end

  def extract_locale_from_header
    accept_language = request.headers["Accept-Language"]
    return unless accept_language

    locale = accept_language.scan(/([a-z]{2}(?:-[A-Z]{2})?)/).map(&:first).first
    I18n.available_locales.map(&:to_s).include?(locale) ? locale : nil
  end

  def set_default_response_format
    request.format = :json
  end
end
