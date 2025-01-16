module V1
  class ApplicationContract < Dry::Validation::Contract
    config.messages.backend = :i18n
    config.messages.default_locale = I18n.locale

    def self.validate(options)
      new.call(options)
    end

    def self.call(options)
      new.call(options)
    end
  end
end
