# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ShippingV2
      # Carrier Related Info
      Carrier = Structure.new do
        # @return [String]
        attribute(:id, String, null: false)

        # @return [String]
        attribute(:name, String, null: false)
      end
    end
  end
end
