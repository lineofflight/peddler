# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AmazonWarehousingAndDistribution20240509
      # Shipment label page types.
      ShipmentLabelPageTypes = Structure.new do
        # @return [String] Status of label page types.
        attribute(:label_status, String, null: false, from: "labelStatus")

        # @return [Array<PageType>] List of available page types.
        attribute?(:page_types, Array, from: "pageTypes")
      end
    end
  end
end
