# typed: false
# frozen_string_literal: true

class TodoCleanupJob < ApplicationJob
  queue_as :low

  sidekiq_options lock: :until_executed

  def perform(days_old: 30)
    # Clean up completed todos older than specified days
    cutoff_date = days_old.days.ago
    deleted_count = Todo.completed.where(updated_at: ...cutoff_date).destroy_all.count

    Rails.logger.info("TodoCleanupJob: Deleted #{deleted_count} completed todos older than #{days_old} days")
  end
end
