# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class ShippingV2
      # Active Account Details
      CollectionFormsHistoryRecord = Structure.new do
        # @return [String]
        attribute?(:carrier_name, String, from: "carrierName")

        # @return [String]
        attribute?(:collection_form_id, String, from: "collectionFormId")

        # @return [Time] Creation Time for this account.
        attribute?(:creation_date, Time, from: "creationDate")

        # @return [String]
        attribute?(:generation_status, String, from: "generationStatus")

        # @return [Address]
        attribute?(:ship_from_address, Address, from: "shipFromAddress")
      end
    end
  end
end
