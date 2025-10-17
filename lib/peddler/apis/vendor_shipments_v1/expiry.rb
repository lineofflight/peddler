# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class VendorShipmentsV1
      # Expiry refers to the collection of dates required for certain items. These could be either expiryDate or mfgDate
      # and expiryAfterDuration. These are mandatory for perishable items.
      Expiry = Structure.new do
        # @return [Duration] Duration after manufacturing date during which the product is valid for consumption.
        attribute?(:expiry_after_duration, Duration, from: "expiryAfterDuration")

        # @return [Time] The date that determines the limit of consumption or use of a product. Its meaning is
        #   determined based on the trade item context.
        attribute?(:expiry_date, Time, from: "expiryDate")

        # @return [Time] Production, packaging or assembly date determined by the manufacturer. Its meaning is
        #   determined based on the trade item context.
        attribute?(:manufacturer_date, Time, from: "manufacturerDate")
      end
    end
  end
end
