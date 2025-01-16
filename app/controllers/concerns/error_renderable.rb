module ErrorRenderable
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_error
    rescue_from ActiveRecord::RecordNotFound, with: :render_record_not_found_error
    rescue_from Pundit::NotAuthorizedError, with: :render_pundit_not_authorized_error
    rescue_from ActionController::ParameterMissing, with: :render_parameter_missing_error
    rescue_from Errors::Authentication, with: :render_error
    rescue_from Errors::Forbidden, with: :render_error
    rescue_from Errors::Unauthorized, with: :render_error
    rescue_from Errors::NotFound, with: :render_error
    rescue_from Errors::Validation, with: :render_error
    rescue_from Errors::SchemaValidation, with: :render_error
  end

  def render_unprocessable_entity_error(exception)
    render_error(Errors::Validation.new(exception.record), :unprocessable_entity)
  end

  def render_record_not_found_error(exception)
    render_error(Errors::NotFound.new(nil, exception.message))
  end

  def render_pundit_not_authorized_error(_)
    render_error(Errors::Unauthorized.new)
  end

  def render_parameter_missing_error(exception)
    render_error(Errors::Validation.new(exception.record))
  end

  # Common error serialized response
  def render_error(exception, status = nil)
    render json: ErrorSerializer.new(exception), status: status || exception.status
  end
end
