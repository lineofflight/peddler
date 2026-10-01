# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AplusContent20201101
      # A single frequently asked question with its corresponding answer.
      Faq = Structure.new do
        # @return [ParagraphComponent]
        attribute(:answer, ParagraphComponent, null: false)

        # @return [ParagraphComponent]
        attribute(:question, ParagraphComponent, null: false)
      end
    end
  end
end
