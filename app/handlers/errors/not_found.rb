module Errors
  class NotFound < Errors::Standard
    def initialize(code, detail)
      super(
        code: code || "err.not_found",
        status: 404,
        detail: detail
      )
    end
  end
end
