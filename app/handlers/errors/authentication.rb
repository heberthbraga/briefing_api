module Errors
  class Authentication < Errors::Standard
    def initialize
      super(
        code: "err.authentication",
        status: 401,
        detail: "Failed to authenticate"
      )
    end
  end
end
