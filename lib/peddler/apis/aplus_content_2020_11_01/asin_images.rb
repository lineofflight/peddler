# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AplusContent20201101
      # Wrapper for a single ASIN image entry.
      ASINImages = Structure.new do
        # @return [ASINImage]
        attribute(:asin_image, ASINImage, null: false, from: "asinImage")
      end
    end
  end
end
