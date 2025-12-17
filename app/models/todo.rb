# typed: false
# frozen_string_literal: true

class Todo < ApplicationRecord
  # Validations
  validates :title, presence: true, length: { minimum: 1, maximum: 255 }
  validates :completed, inclusion: { in: [true, false] }
  validates :position, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  # Scopes
  scope :ordered, -> { order(position: :asc) }
  scope :completed, -> { where(completed: true) }
  scope :active, -> { where(completed: false) }

  # Callbacks
  before_validation :set_position, on: :create

  # Instance methods
  def toggle!
    update!(completed: !completed)
  end

  private

  def set_position
    self.position ||= (Todo.maximum(:position) || 0) + 1
  end
end
