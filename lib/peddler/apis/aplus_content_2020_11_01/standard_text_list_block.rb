# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AplusContent20201101
      # The A+ Content standard fixed-length list of text, usually presented as bullet points.
      StandardTextListBlock = Structure.new do
        # @return [Array<TextItem>]
        attribute(:text_list, [TextItem], from: "textList")
      end
    end
  end
end
