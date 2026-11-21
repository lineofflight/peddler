# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module AplusContent20201101
      # A reference to an image, hosted in the A+ Content media library.
      ImageComponent = Structure.new do
        # The alternative text for the image.
        attribute(:alt_text, String, null: false, from: "altText")

        attribute(:image_crop_specification, ImageCropSpecification, null: false, from: "imageCropSpecification")

        # This identifier is provided by the Selling Partner API for Uploads.
        attribute(:upload_destination_id, String, null: false, from: "uploadDestinationId")
      end
    end
  end
end
