# typed: false
# frozen_string_literal: true

class FileUploader < Shrine
  # General file uploader with basic size validation

  Attacher.validate do
    validate_max_size 50 * 1024 * 1024, message: "is too large (max is 50 MB)"
  end
end
