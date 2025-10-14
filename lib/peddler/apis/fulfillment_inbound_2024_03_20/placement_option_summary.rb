# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentInbound20240320
      # Summary information about a placement option.
      PlacementOptionSummary = Structure.new do
        # @return [String] The identifier of a placement option. A placement option represents the shipment splits and
        # destinations of SKUs.
        attribute(:placement_option_id, String, from: "placementOptionId")

        # @return [String] The status of a placement option. Possible values: `OFFERED`, `ACCEPTED`.
        attribute(:status, String)
      end
    end
  end
end
