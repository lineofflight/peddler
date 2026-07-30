# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentOutbound20260704
      # The Amazon facility from which the shipment is sent.
      AmazonFacility = Structure.new do
        # @return [String] An identifier for the Amazon facility from which the shipment is sent.
        attribute(:facility_id, String, null: false, from: "facilityId")

        # @return [Address] The facility address from which the shipment originated.
        attribute?(:address, Address)
      end
    end
  end
end
