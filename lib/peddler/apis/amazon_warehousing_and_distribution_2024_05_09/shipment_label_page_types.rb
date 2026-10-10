# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module AmazonWarehousingAndDistribution20240509
      # Shipment label page types.
      ShipmentLabelPageTypes = Structure.new do
        # Status of label page types.
        attribute(:label_status, String, null: false, from: "labelStatus")

        # List of available page types.
        attribute?(:page_types, Array, from: "pageTypes")
      end
    end
  end
end
