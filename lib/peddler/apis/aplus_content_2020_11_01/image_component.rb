# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AplusContent20201101
      # A reference to an image, hosted in the A+ Content media library.
      ImageComponent = Structure.new do
        # @return [String] The alternative text for the image.
        attribute(:alt_text, String, from: "altText")

        # @return [ImageCropSpecification]
        attribute(:image_crop_specification, ImageCropSpecification, from: "imageCropSpecification")

        # @return [String] This identifier is provided by the [Uploads
        # API](https://developer-docs.amazon.com/sp-api/reference/welcome-to-api-references).
        attribute(:upload_destination_id, String, from: "uploadDestinationId")
      end
    end
  end
end
