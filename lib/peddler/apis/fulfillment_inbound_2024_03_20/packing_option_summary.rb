# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FulfillmentInbound20240320
      # Summary information about a packing option.
      PackingOptionSummary = Structure.new do
        # Identifier of a packing option.
        attribute(:packing_option_id, String, null: false, from: "packingOptionId")

        # The status of a packing option. Possible values: 'OFFERED', 'ACCEPTED', 'EXPIRED'.
        attribute(:status, String, null: false)
      end
    end
  end
end
