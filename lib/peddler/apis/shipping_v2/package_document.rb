# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ShippingV2
      # A document related to a package.
      PackageDocument = Structure.new do
        # @return [String]
        attribute(:contents, String, null: false)

        # @return [String]
        attribute(:format, String, null: false)

        # @return [String]
        attribute(:type, String, null: false)
      end
    end
  end
end
