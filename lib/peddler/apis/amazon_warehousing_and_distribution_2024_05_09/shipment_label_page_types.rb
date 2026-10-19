# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module AmazonWarehousingAndDistribution20240509
      # Shipment label page types.
      ShipmentLabelPageTypes = Structure.new do
        # Status of label page types. Known values: `GENERATING`, `GENERATED`, `GENERATION_FAILED`, `NOT_READY`.
        attribute(:label_status, String, null: false, from: "labelStatus")

        # List of available page types. Known values: `PLAIN_PAPER`, `LETTER_PCP_FULFILLMENTLABEL`,
        # `LETTER_2_HORIZONTAL`, `LETTER_2`, `THERMAL_NO_CARRIER_ROTATION`, `THERMAL`, `A4_PAPER`, `A4_2_HORIZONTAL`,
        # `THERMAL_SQUARE_10CM`.
        attribute?(:page_types, Array, from: "pageTypes")
      end
    end
  end
end
