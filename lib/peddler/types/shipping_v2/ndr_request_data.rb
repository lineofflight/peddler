# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module ShippingV2
      # Additional information required for the NDR action that has been filed. If the NDR Action is RESCHEDULE,
      # rescheduleDate is a required field. Otherwise, if the NDR Action is REATTEMPT, additionalAddressNotes is a
      # required field.
      NdrRequestData = Structure.new do
        # @return [String] The date on which the Seller wants to reschedule shipment delivery, in ISO-8601 date/time
        # format
        attribute(:reschedule_date, String, from: "rescheduleDate")

        # @return [String]
        attribute(:additional_address_notes, String, from: "additionalAddressNotes")
      end
    end
  end
end
