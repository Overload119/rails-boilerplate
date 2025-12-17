# typed: false
# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include InertiaFlash

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Share common data with all Inertia pages
  inertia_share do
    {
      # App metadata
      app: {
        name: "Rails TODO",
        version: app_version,
      },
    }
  end

  private

  def app_version
    Rails.application.config.version
  rescue StandardError
    "1.0.0"
  end
end
