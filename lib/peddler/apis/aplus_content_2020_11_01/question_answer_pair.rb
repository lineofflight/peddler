# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AplusContent20201101
      # A single question and answer pair.
      QuestionAnswerPair = Structure.new do
        # @return [ParagraphComponent]
        attribute(:answer, ParagraphComponent, null: false)

        # @return [TextComponent]
        attribute(:question, TextComponent, null: false)
      end
    end
  end
end
