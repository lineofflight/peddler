# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ShippingV2
      # A document related to a package.
      PackageDocument = Structure.new do
        attribute(:contents, String, null: false)

        # Known values: `PDF`, `PNG`, `ZPL`.
        attribute(:format, String, null: false)

        # Known values: `PACKSLIP`, `LABEL`, `RECEIPT`, `CUSTOM_FORM`.
        attribute(:type, String, null: false)
      end
    end
  end
end
