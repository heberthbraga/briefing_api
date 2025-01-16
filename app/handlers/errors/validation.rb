module Errors
  class Validation < Errors::Standard
    def initialize(record)
      super(
        code: "err.validation",
        status: 400,
        detail: "Validation Error",
        data: handle_errors(record, record.errors)
      )
    end

    private

    def handle_errors(record, errors)
      errors.details.flat_map do |field, details|
        details.map { |error_details| ValidationErrorSerializer.new(record, field, error_details).serialize }
      end
    end
  end
end
