module Errors
  class SchemaValidation < Errors::Standard
    def initialize(schema, errors)
      super(
        code: "err.schema.validation",
        status: 422,
        detail: "Request Schema Validation Error",
        data: handle_errors(schema, errors)
      )
    end

    private

    def handle_errors(schema, errors)
      parsed_errors = JSON.parse(errors)
      parsed_errors.flat_map do |field, error_details|
        ValidationErrorSerializer.new("#{schema}", field, error_details)
      end
    end
  end
end
