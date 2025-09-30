# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/shipping_v2/address"

module Peddler
  module Types
    module ShippingV2
      # Active Account Details
      CollectionFormsHistoryRecord = Structure.new do
        # @return [String]
        attribute?(:carrier_name, String, from: "carrierName")

        # @return [String] Creation Time for this account.
        attribute?(:creation_date, String, from: "creationDate")

        # @return [String]
        attribute?(:generation_status, String, from: "generationStatus")

        # @return [String]
        attribute?(:collection_form_id, String, from: "collectionFormId")

        # @return [Address]
        attribute?(:ship_from_address, Address, from: "shipFromAddress")
      end
    end
  end
end
