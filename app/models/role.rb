class Role < ApplicationRecord
  has_and_belongs_to_many :permissions

  belongs_to :resource, polymorphic: true, optional: true

  validates :resource_type, inclusion: { in: Rolify.resource_types }, allow_nil: true
  validates :name, presence: true, uniqueness: true
end
