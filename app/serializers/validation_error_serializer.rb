class ValidationErrorSerializer
  def initialize(record, field, details)
    @record = record
    @field = field
    @details = details
  end

  def serialize
    {
      resource: resource,
      field: field,
      code: code
    }
  end

  private

  def resource
    I18n.t(
      underscored_resource_name,
      scope: [ :resources ],
      locale: :en,
      default: @record.class.to_s
    )
  end

  def field
    I18n.t(
      @field,
      scope: [ :fields, underscored_resource_name ],
      locale: :en,
      default: @field.to_s
    )
  end

  def code
    I18n.t(
      @details[:error],
      scope: %i[errors codes],
      locale: :en,
      default: @details[:error].to_s
    )
  end

  def underscored_resource_name
    @record.class.to_s.gsub("::", "").underscore
  end
end
