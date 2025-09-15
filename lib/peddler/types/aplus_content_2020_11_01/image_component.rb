# frozen_string_literal: true

require "peddler/types/aplus_content_2020_11_01/image_crop_specification"

module Peddler
  module Types
    module AplusContent20201101
      # A reference to an image, hosted in the A+ Content media library.
      ImageComponent = Structure.new do
        # @return [String] This identifier is provided by the [Uploads
        # API](https://developer-docs.amazon.com/sp-api/reference/welcome-to-api-references).
        attribute(:upload_destination_id, String, from: "uploadDestinationId")

        # @return [ImageCropSpecification]
        attribute(:image_crop_specification, ImageCropSpecification, from: "imageCropSpecification")

        # @return [String] The alternative text for the image.
        attribute(:alt_text, String, from: "altText")
      end
    end
  end
end
