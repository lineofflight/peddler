# frozen_string_literal: true

require "peddler/types/aplus_content_2020_11_01/standard_image_text_caption_block"

module Peddler
  module Types
    module AplusContent20201101
      # Standard images with text, presented one at a time. The user clicks on thumbnails to view each block.
      StandardMultipleImageTextModule = Structure.new do
        # @return [Array<StandardImageTextCaptionBlock>]
        attribute(:blocks, [StandardImageTextCaptionBlock])
      end
    end
  end
end
