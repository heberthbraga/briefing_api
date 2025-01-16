module Renderable
  extend ActiveSupport::Concern

  def render_json(serializer, entity, status)
    render json: serializer.new(entity).to_h, status: status
  end
end
