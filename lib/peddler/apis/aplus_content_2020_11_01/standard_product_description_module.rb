# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AplusContent20201101
      # Standard product description text.
      StandardProductDescriptionModule = Structure.new do
        # @return [ParagraphComponent]
        attribute(:body, ParagraphComponent)
      end
    end
  end
end
