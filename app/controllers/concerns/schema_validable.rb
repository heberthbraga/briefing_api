# frozen_string_literal: true

module SchemaValidable
  extend ActiveSupport::Concern

  included do
    before_action :validate_schema
  end

  private

  def required_schema_validation!(schema, params)
    return true if schema.nil? || params.blank?
    result = schema.call(params.to_h)

    return true if result.success?

    error_message = result.errors(full: true).to_h.to_json

    raise Errors::SchemaValidation.new(schema, error_message)
  end

  def validate_schema
    return unless schema_for_action

    required_schema_validation!(schema_for_action, permitted_params)
  end

  def permitted_params
    send("#{action_name}_permitted_params")
  end

  def schema_for_action
    self.class::SCHEMAS[action_name.to_sym] || default_schema
  rescue NameError
    default_schema
  end

  def default_schema
    nil
  end
end
