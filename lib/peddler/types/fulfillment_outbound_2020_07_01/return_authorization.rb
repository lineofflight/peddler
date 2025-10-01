# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/fulfillment_outbound_2020_07_01/address"

module Peddler
  module Types
    module FulfillmentOutbound20200701
      # Return authorization information for items accepted for return.
      ReturnAuthorization = Structure.new do
        # @return [String] The return merchandise authorization (RMA) that Amazon needs to process the return.
        attribute(:amazon_rma_id, String, from: "amazonRmaId")

        # @return [String] An identifier for the Amazon fulfillment center to which the return items should be sent.
        attribute(:fulfillment_center_id, String, from: "fulfillmentCenterId")

        # @return [String] An identifier for the return authorization. This identifier associates return items with the
        # return authorization used to return them.
        attribute(:return_authorization_id, String, from: "returnAuthorizationId")

        # @return [Address] The address of the Amazon fulfillment center that the return items should be sent to.
        attribute(:return_to_address, Address, from: "returnToAddress")

        # @return [String] A URL for a web page that contains the return authorization barcode and the mailing label.
        # This does not include pre-paid shipping.
        attribute(:rma_page_url, String, from: "rmaPageURL")
      end
    end
  end
end
