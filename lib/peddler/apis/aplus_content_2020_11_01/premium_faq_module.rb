# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module AplusContent20201101
      # A list of question-and-answer pairs with a configurable background color scheme of light or dark.
      PremiumFaqModule = Structure.new do
        # The collection of FAQ entries, which must contain between 2 and 5 FAQs.
        attribute(:faqs, [Faqs], null: false)

        attribute?(:color_type, String, from: "colorType")
      end
    end
  end
end
