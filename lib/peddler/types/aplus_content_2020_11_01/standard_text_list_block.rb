# frozen_string_literal: true

require "peddler/types/aplus_content_2020_11_01/text_item"

module Peddler
  module Types
    module AplusContent20201101
      # The A+ Content standard fixed-length list of text, usually presented as bullet points.
      StandardTextListBlock = Structure.new do
        # @return [Array<TextItem>]
        attribute(:text_list, [TextItem], from: "textList")
      end
    end
  end
end
