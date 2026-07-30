# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentOutbound20260704
      # Proof of delivery information for a package.
      ProofOfDelivery = Structure.new do
        # @return [String] URL of the delivery photo.
        attribute?(:delivery_photo_url, String, from: "deliveryPhotoUrl")

        # @return [String] The name of the person who received the package.
        attribute?(:received_by, String, from: "receivedBy")
      end
    end
  end
end
