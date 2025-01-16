module Errors
  class Forbidden < Errors::Standard
    def initialize(detail)
      super(
        code: "err.forbidden",
        status: 403,
        detail: detail
      )
    end
  end
end
