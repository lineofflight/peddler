# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module DataKiosk
    module Economics20240315
      # The advertisements spend data summary for the seller's account aggregated by transaction event type: charge.
      AdSummary = Structure.new do
        # Advertisement type name, for example: "Sponsored Products charge".
        attribute?(:ad_type_name, String, null: false, from: "adTypeName")

        # Charge aggregated detail for an advertisement type.
        attribute?(:charge, AggregatedDetail)
      end
    end
  end
end
