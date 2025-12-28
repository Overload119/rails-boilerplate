# typed: false
# frozen_string_literal: true

class ImageUploader < Shrine
  # Plugins specific to image uploads can be added here
  # plugin :derivatives         # for image processing/thumbnails
  # plugin :store_dimensions    # stores image dimensions

  Attacher.validate do
    validate_max_size 10 * 1024 * 1024, message: "is too large (max is 10 MB)"
    validate_mime_type ["image/jpeg", "image/png", "image/gif", "image/webp"], message: "must be a JPEG, PNG, GIF, or WebP"
    validate_extension ["jpg", "jpeg", "png", "gif", "webp"], message: "must be a jpg, png, gif, or webp"
  end
end
