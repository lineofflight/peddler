# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AplusContent20201101
      # An accessibility description for a specific locale.
      Description = Structure.new do
        # @return [String] A locale identifier (for example, `en-US`, `de-DE`).
        attribute(:locale, String, null: false)

        # @return [String] The accessibility description text for the locale.
        attribute(:value, String, null: false)
      end
    end
  end
end
