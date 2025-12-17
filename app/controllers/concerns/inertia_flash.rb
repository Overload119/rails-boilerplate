# typed: false
# frozen_string_literal: true

# Concern to share flash messages with Inertia
module InertiaFlash
  extend ActiveSupport::Concern

  included do
    inertia_share flash: -> {
      {
        success: flash[:success] || flash[:notice],
        error: flash[:error] || flash[:alert],
        info: flash[:info],
      }.compact
    }
  end
end
