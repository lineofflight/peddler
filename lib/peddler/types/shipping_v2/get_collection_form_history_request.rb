# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/shipping_v2/client_reference_detail"
require "peddler/types/shipping_v2/address"
require "peddler/types/shipping_v2/date_range"

module Peddler
  module Types
    module ShippingV2
      # The request schema to get query collections form history API .
      GetCollectionFormHistoryRequest = Structure.new do
        # @return [Array<ClientReferenceDetail>]
        attribute(:client_reference_details, [ClientReferenceDetail], from: "clientReferenceDetails")

        # @return [Integer] max Number of Results for query .
        attribute(:max_results, Integer, from: "maxResults")

        # @return [String]
        attribute(:carrier_id, String, from: "carrierId")

        # @return [Address]
        attribute(:ship_from_address, Address, from: "shipFromAddress")

        # @return [DateRange]
        attribute(:date_range, DateRange, from: "dateRange")
      end
    end
  end
end
