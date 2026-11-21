# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    module ShippingV2
      # The request schema to get query collections form history API .
      GetCollectionFormHistoryRequest = Structure.new do
        attribute?(:carrier_id, String, from: "carrierId")

        attribute?(:client_reference_details, [ClientReferenceDetail], from: "clientReferenceDetails")

        attribute?(:date_range, DateRange, from: "dateRange")

        # max Number of Results for query .
        attribute?(:max_results, Integer, from: "maxResults")

        attribute?(:ship_from_address, Address, from: "shipFromAddress")
      end
    end
  end
end
