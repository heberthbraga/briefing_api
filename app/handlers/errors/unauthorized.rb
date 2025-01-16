# frozen_string_literal: true

module Errors
  class Unauthorized < Forbidden
    def initialize
      super(I18n.t("errors.unauthorized"))
    end
  end
end
