# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class ShippingV2
      # The request schema to get query collections form history API .
      GetCollectionFormHistoryRequest = Structure.new do
        # @return [String]
        attribute?(:carrier_id, String, from: "carrierId")

        # @return [Array<ClientReferenceDetail>]
        attribute?(:client_reference_details, [ClientReferenceDetail], from: "clientReferenceDetails")

        # @return [DateRange]
        attribute?(:date_range, DateRange, from: "dateRange")

        # @return [Integer] max Number of Results for query .
        attribute?(:max_results, Integer, from: "maxResults")

        # @return [Address]
        attribute?(:ship_from_address, Address, from: "shipFromAddress")
      end
    end
  end
end
