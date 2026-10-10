# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module AplusContent20201101
      # A single frequently asked question with its corresponding answer.
      Faq = Structure.new do
        attribute(:answer, ParagraphComponent, null: false)

        attribute(:question, ParagraphComponent, null: false)
      end
    end
  end
end
