# typed: false
# frozen_string_literal: true

InertiaRails.configure do |config|
  # Deep merge shared data (useful for nested objects like flash messages)
  config.deep_merge_shared_data = true

  # Always include errors hash to comply with Inertia protocol
  config.always_include_errors_hash = true

  # Version your assets for cache busting
  # When this changes, Inertia will do a full page reload
  config.version = lambda {
    if Rails.env.production?
      # In production, use a digest of the JS bundle
      begin
        Digest::SHA256.file(Rails.root.join("app/assets/builds/inertia.js")).hexdigest
      rescue
        nil
      end
    end
  }
end
