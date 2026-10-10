# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ShippingV2
      # A document related to a package.
      PackageDocument = Structure.new do
        attribute(:contents, String, null: false)

        attribute(:format, String, null: false)

        attribute(:type, String, null: false)
      end
    end
  end
end
