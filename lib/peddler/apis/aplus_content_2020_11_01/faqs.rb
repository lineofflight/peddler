# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AplusContent20201101
      # A wrapper object for a single FAQ entry.
      Faqs = Structure.new do
        # @return [Faq]
        attribute(:faq, Faq, null: false)
      end
    end
  end
end
