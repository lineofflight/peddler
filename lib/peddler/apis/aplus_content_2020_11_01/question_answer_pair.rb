# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module AplusContent20201101
      # A single question and answer pair.
      QuestionAnswerPair = Structure.new do
        attribute(:answer, ParagraphComponent, null: false)

        attribute(:question, TextComponent, null: false)
      end
    end
  end
end
