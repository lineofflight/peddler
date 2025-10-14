# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AplusContent20201101
      # The instructions for optionally cropping an image. If you don't want to crop the image, set the dimensions to
      # the original image size. If the image is cropped and you don't include offset values, the coordinates of the top
      # left corner of the cropped image are set to (0,0) by default.
      ImageCropSpecification = Structure.new do
        # @return [ImageDimensions]
        attribute(:size, ImageDimensions)

        # @return [ImageOffsets]
        attribute?(:offset, ImageOffsets)
      end
    end
  end
end
