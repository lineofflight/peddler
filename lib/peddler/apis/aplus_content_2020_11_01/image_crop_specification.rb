# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AplusContent20201101
      # The instructions for optionally cropping an image. If no cropping is desired, set the dimensions to the original
      # image size. If the image is cropped and no offset values are provided, then the coordinates of the top left
      # corner of the cropped image, relative to the original image, are defaulted to (0,0).
      ImageCropSpecification = Structure.new do
        # @return [ImageDimensions]
        attribute(:size, ImageDimensions, null: false)

        # @return [ImageOffsets]
        attribute?(:offset, ImageOffsets)
      end
    end
  end
end
