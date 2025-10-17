# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class ShippingV2
      # Additional information required for the NDR action that has been filed. If the NDR Action is RESCHEDULE,
      # rescheduleDate is a required field. Otherwise, if the NDR Action is REATTEMPT, additionalAddressNotes is a
      # required field.
      NdrRequestData = Structure.new do
        # @return [String]
        attribute?(:additional_address_notes, String, from: "additionalAddressNotes")

        # @return [Time] The date on which the Seller wants to reschedule shipment delivery, in ISO-8601 date/time
        #   format
        attribute?(:reschedule_date, Time, from: "rescheduleDate")
      end
    end
  end
end
