# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    module ShippingV2
      # Active Account Details
      CollectionFormsHistoryRecord = Structure.new do
        attribute?(:carrier_name, String, from: "carrierName")

        attribute?(:collection_form_id, String, from: "collectionFormId")

        # Creation Time for this account.
        attribute?(:creation_date, Time, from: "creationDate")

        # Known values: `Completed`, `InProgress`.
        attribute?(:generation_status, String, from: "generationStatus")

        attribute?(:ship_from_address, Address, from: "shipFromAddress")
      end
    end
  end
end
