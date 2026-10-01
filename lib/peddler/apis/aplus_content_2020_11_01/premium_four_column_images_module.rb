# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AplusContent20201101
      # Four images displayed in a row with a single headline above. Each image has its own subheadline and body text.
      PremiumFourColumnImagesModule = Structure.new do
        # @return [Array<ImageColumns>] The collection of image columns, which must contain between 3 and 4 columns.
        attribute(:columns, [ImageColumns], null: false)

        # @return [TextComponent]
        attribute?(:headline, TextComponent)
      end
    end
  end
end
