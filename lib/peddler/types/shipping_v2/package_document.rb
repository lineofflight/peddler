# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module ShippingV2
      # A document related to a package.
      PackageDocument = Structure.new do
        # @return [String]
        attribute(:type, String)

        # @return [String]
        attribute(:format, String)

        # @return [String]
        attribute(:contents, String)
      end
    end
  end
end
