# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ShippingV2
      # The response schema for the the getShipmentDocuments operation.
      GetShipmentDocumentsResponse = Structure.new do
        attribute?(:payload, GetShipmentDocumentsResult)
      end
    end
  end
end
