# frozen_string_literal: true

require "peddler/types/vendor_shipments_v1/duration"

module Peddler
  module Types
    module VendorShipmentsV1
      # Expiry refers to the collection of dates required for certain items. These could be either expiryDate or mfgDate
      # and expiryAfterDuration. These are mandatory for perishable items.
      Expiry = Structure.new do
        # @return [String] Production, packaging or assembly date determined by the manufacturer. Its meaning is
        # determined based on the trade item context.
        attribute(:manufacturer_date, String, from: "manufacturerDate")

        # @return [String] The date that determines the limit of consumption or use of a product. Its meaning is
        # determined based on the trade item context.
        attribute(:expiry_date, String, from: "expiryDate")

        # @return [Duration] Duration after manufacturing date during which the product is valid for consumption.
        attribute(:expiry_after_duration, Duration, from: "expiryAfterDuration")
      end
    end
  end
end
