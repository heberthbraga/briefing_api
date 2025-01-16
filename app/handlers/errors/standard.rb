module Errors
  class Standard < ::StandardError
    def initialize(code: nil, detail: nil, status: nil, data: [])
      @code = code || "err.internal"
      @detail = detail || "We encountered unexpected error, but our developers had been already notified about it"
      @status = status || 500
      @data = data
    end

    def to_h
      {
        code: code,
        detail: detail,
        status: status,
        data: data
      }
    end

    def serializable_hash
      to_h
    end

    delegate :to_s, to: :to_h

    attr_reader :code, :detail, :status, :data
  end
end