# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentInbound20240320
      # Summary information about a packing option.
      PackingOptionSummary = Structure.new do
        # @return [String] Identifier of a packing option.
        attribute(:packing_option_id, String, null: false, from: "packingOptionId")

        # @return [String] The status of a packing option. Possible values: 'OFFERED', 'ACCEPTED', 'EXPIRED'.
        attribute(:status, String, null: false)
      end
    end
  end
end
