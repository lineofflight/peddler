# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentOutbound20200701
      # The delivery information of the package, this information is only available post package delivery to its
      # intended destination.
      DeliveryInformation = Structure.new do
        # @return [Array<DeliveryDocument>] All of the delivery documents for a package.
        attribute?(:delivery_document_list, [DeliveryDocument], from: "deliveryDocumentList")

        # @return [DropOffLocation] The drop off location for a package.
        attribute?(:drop_off_location, DropOffLocation, from: "dropOffLocation")
      end
    end
  end
end
