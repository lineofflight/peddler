# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AplusContent20201101
      # Standard images with text, presented one at a time. The user clicks on thumbnails to view each block.
      StandardMultipleImageTextModule = Structure.new do
        # @return [Array<StandardImageTextCaptionBlock>]
        attribute?(:blocks, [StandardImageTextCaptionBlock])
      end
    end
  end
end
