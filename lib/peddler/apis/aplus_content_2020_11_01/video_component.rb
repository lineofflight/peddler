# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AplusContent20201101
      # A reference to a video asset hosted within A+, including metadata and a preview thumbnail image.
      VideoComponent = Structure.new do
        # @return [ImageCropSpecification]
        attribute(:image_crop_specification, ImageCropSpecification, null: false, from: "imageCropSpecification")

        # @return [String] This identifier is provided by the create media response, used to locate an uploaded image
        #   file.
        attribute(:image_media_id, String, null: false, from: "imageMediaId")

        # @return [String] This identifier is provided by the create media response, used to locate an uploaded video
        #   file.
        attribute(:video_media_id, String, null: false, from: "videoMediaId")
      end
    end
  end
end
